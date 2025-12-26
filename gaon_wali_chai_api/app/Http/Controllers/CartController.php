<?php

namespace App\Http\Controllers;

use App\Models\CartItem;
use App\Models\CartItemVariant;
use App\Models\Product;
use App\Models\ProductSize;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CartController extends Controller
{
    /**
     * Get user's cart
     */
    public function index(Request $request)
    {
        $user = $request->user();
        
        $cartItems = CartItem::with(['product.category', 'size', 'variants.variant'])
            ->where('user_id', $user->id)
            ->get();

        $items = $cartItems->map(function ($item) {
            return [
                'id' => $item->id,
                'user_id' => $item->user_id,
                'product_id' => $item->product_id,
                'size_id' => $item->size_id,
                'quantity' => $item->quantity,
                'product' => [
                    'id' => $item->product->id,
                    'name' => $item->product->name,
                    'description' => $item->product->description,
                    'base_price' => $item->product->base_price,
                    'image' => $item->product->image,
                    'category_id' => $item->product->category_id,
                    'is_featured' => $item->product->is_featured,
                    'is_available' => $item->product->is_available,
                ],
                'size' => [
                    'id' => $item->size->id,
                    'product_id' => $item->size->product_id,
                    'name' => $item->size->name,
                    'price' => $item->size->price,
                    'is_available' => $item->size->is_available,
                ],
                'variants' => $item->variants->map(function ($cv) {
                    return [
                        'id' => $cv->variant->id,
                        'product_id' => $cv->variant->product_id,
                        'name' => $cv->variant->name,
                        'price' => $cv->variant->price,
                        'image' => $cv->variant->image,
                        'is_available' => $cv->variant->is_available,
                    ];
                }),
                'created_at' => $item->created_at->toIso8601String(),
                'updated_at' => $item->updated_at->toIso8601String(),
            ];
        });

        $subtotal = $cartItems->sum(function ($item) {
            return $item->calculateTotal();
        });
        $tax = round($subtotal * 0.05, 2); // 5% tax
        $deliveryFee = 20;
        $total = $subtotal + $tax + $deliveryFee;

        return response()->json([
            'data' => [
                'items' => $items,
                'subtotal' => $subtotal,
                'tax' => $tax,
                'delivery_fee' => $deliveryFee,
                'total' => $total,
            ]
        ]);
    }

    /**
     * Add item to cart
     */
    public function add(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'size_id' => 'required|exists:product_sizes,id',
            'quantity' => 'required|integer|min:1',
            'variant_ids' => 'nullable|array',
            'variant_ids.*' => 'exists:product_variants,id',
        ]);

        $user = $request->user();

        // Check if product is available
        $product = Product::findOrFail($request->product_id);
        if (!$product->is_available) {
            return response()->json([
                'message' => 'Product is not available'
            ], 400);
        }

        // Check if size belongs to product
        $size = ProductSize::where('product_id', $request->product_id)
            ->where('id', $request->size_id)
            ->firstOrFail();

        DB::beginTransaction();
        try {
            // Check if item already exists in cart
            $cartItem = CartItem::where('user_id', $user->id)
                ->where('product_id', $request->product_id)
                ->where('size_id', $request->size_id)
                ->first();

            if ($cartItem) {
                // Update quantity
                $cartItem->quantity += $request->quantity;
                $cartItem->save();
            } else {
                // Create new cart item
                $cartItem = CartItem::create([
                    'user_id' => $user->id,
                    'product_id' => $request->product_id,
                    'size_id' => $request->size_id,
                    'quantity' => $request->quantity,
                ]);
            }

            // Add variants
            if ($request->has('variant_ids')) {
                // Remove existing variants if updating
                CartItemVariant::where('cart_item_id', $cartItem->id)->delete();
                
                foreach ($request->variant_ids as $variantId) {
                    CartItemVariant::create([
                        'cart_item_id' => $cartItem->id,
                        'variant_id' => $variantId,
                    ]);
                }
            }

            DB::commit();

            // Get updated cart count
            $cartCount = CartItem::where('user_id', $user->id)->sum('quantity');

            return response()->json([
                'message' => 'Item added to cart',
                'data' => [
                    'cart_item_id' => $cartItem->id,
                    'cart_count' => $cartCount,
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to add item to cart',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update cart item quantity
     */
    public function update(Request $request, $itemId)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $user = $request->user();
        
        $cartItem = CartItem::where('user_id', $user->id)
            ->where('id', $itemId)
            ->firstOrFail();

        $cartItem->quantity = $request->quantity;
        $cartItem->save();

        // Reload with relationships
        $cartItem->load(['product.category', 'size', 'variants.variant']);

        return response()->json([
            'message' => 'Cart item updated',
            'data' => [
                'id' => $cartItem->id,
                'user_id' => $cartItem->user_id,
                'product_id' => $cartItem->product_id,
                'size_id' => $cartItem->size_id,
                'quantity' => $cartItem->quantity,
                'product' => [
                    'id' => $cartItem->product->id,
                    'name' => $cartItem->product->name,
                    'description' => $cartItem->product->description,
                    'base_price' => $cartItem->product->base_price,
                    'image' => $cartItem->product->image,
                    'category_id' => $cartItem->product->category_id,
                    'is_featured' => $cartItem->product->is_featured,
                    'is_available' => $cartItem->product->is_available,
                ],
                'size' => [
                    'id' => $cartItem->size->id,
                    'product_id' => $cartItem->size->product_id,
                    'name' => $cartItem->size->name,
                    'price' => $cartItem->size->price,
                    'is_available' => $cartItem->size->is_available,
                ],
                'variants' => $cartItem->variants->map(function ($cv) {
                    return [
                        'id' => $cv->variant->id,
                        'product_id' => $cv->variant->product_id,
                        'name' => $cv->variant->name,
                        'price' => $cv->variant->price,
                        'image' => $cv->variant->image,
                        'is_available' => $cv->variant->is_available,
                    ];
                }),
                'created_at' => $cartItem->created_at->toIso8601String(),
                'updated_at' => $cartItem->updated_at->toIso8601String(),
            ]
        ]);
    }

    /**
     * Remove item from cart
     */
    public function remove($itemId)
    {
        $user = request()->user();
        
        $cartItem = CartItem::where('user_id', $user->id)
            ->where('id', $itemId)
            ->firstOrFail();

        $cartItem->delete();

        return response()->json([
            'message' => 'Item removed from cart'
        ]);
    }

    /**
     * Clear entire cart
     */
    public function clear()
    {
        $user = request()->user();
        
        CartItem::where('user_id', $user->id)->delete();

        return response()->json([
            'message' => 'Cart cleared'
        ]);
    }
}
