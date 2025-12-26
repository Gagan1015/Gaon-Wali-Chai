<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\OrderItem;
use App\Models\OrderItemVariant;
use App\Models\CartItem;
use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    /**
     * Create a new order
     */
    public function store(Request $request)
    {
        $request->validate([
            'payment_method' => 'required|string',
            'delivery_address_id' => 'required|exists:addresses,id',
            'special_instructions' => 'nullable|string',
        ]);

        $user = $request->user();

        // Verify address belongs to user
        $address = Address::where('id', $request->delivery_address_id)
            ->where('user_id', $user->id)
            ->firstOrFail();

        // Get cart items
        $cartItems = CartItem::with(['product', 'size', 'variants.variant'])
            ->where('user_id', $user->id)
            ->get();

        if ($cartItems->isEmpty()) {
            return response()->json([
                'message' => 'Cart is empty'
            ], 400);
        }

        DB::beginTransaction();
        try {
            // Calculate totals
            $subtotal = 0;
            foreach ($cartItems as $item) {
                $subtotal += $item->calculateTotal();
            }

            $tax = round($subtotal * 0.05, 2); // 5% tax
            $deliveryFee = 20;
            $total = $subtotal + $tax + $deliveryFee;

            // Create order
            $order = Order::create([
                'user_id' => $user->id,
                'order_number' => Order::generateOrderNumber(),
                'subtotal' => $subtotal,
                'tax' => $tax,
                'delivery_fee' => $deliveryFee,
                'total' => $total,
                'status' => 'pending',
                'payment_method' => $request->payment_method,
                'payment_status' => 'pending',
                'delivery_address_id' => $request->delivery_address_id,
                'special_instructions' => $request->special_instructions,
                'estimated_delivery_time' => now()->addMinutes(30),
            ]);

            // Create order items from cart
            foreach ($cartItems as $cartItem) {
                $itemTotal = $cartItem->calculateTotal();

                $orderItem = OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $cartItem->product_id,
                    'product_name' => $cartItem->product->name,
                    'product_image' => $cartItem->product->image,
                    'size_name' => $cartItem->size->name,
                    'size_price' => $cartItem->size->price,
                    'quantity' => $cartItem->quantity,
                    'item_total' => $itemTotal,
                ]);

                // Add variants to order item
                foreach ($cartItem->variants as $cartVariant) {
                    OrderItemVariant::create([
                        'order_item_id' => $orderItem->id,
                        'variant_name' => $cartVariant->variant->name,
                        'variant_price' => $cartVariant->variant->price,
                    ]);
                }
            }

            // Clear cart after order creation
            CartItem::where('user_id', $user->id)->delete();

            DB::commit();

            return response()->json([
                'data' => [
                    'order_id' => $order->order_number,
                    'total' => $order->total,
                    'status' => $order->status,
                    'payment_url' => null, // TODO: Implement payment gateway
                ]
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to create order',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get order details
     */
    public function show($orderNumber)
    {
        $user = request()->user();
        
        $order = Order::with(['items.variants', 'deliveryAddress'])
            ->where('user_id', $user->id)
            ->where('order_number', $orderNumber)
            ->firstOrFail();

        return response()->json([
            'data' => [
                'id' => $order->id,
                'order_number' => $order->order_number,
                'status' => $order->status,
                'items' => $order->items->map(function ($item) {
                    return [
                        'id' => $item->id,
                        'product_id' => $item->product_id,
                        'product_name' => $item->product_name,
                        'product_image' => $item->product_image,
                        'size_name' => $item->size_name,
                        'size_price' => $item->size_price,
                        'quantity' => $item->quantity,
                        'variants' => $item->variants->map(function ($variant) {
                            return [
                                'variant_name' => $variant->variant_name,
                                'variant_price' => $variant->variant_price,
                            ];
                        }),
                        'item_total' => $item->item_total,
                    ];
                }),
                'subtotal' => $order->subtotal,
                'tax' => $order->tax,
                'delivery_fee' => $order->delivery_fee,
                'total' => $order->total,
                'payment_method' => $order->payment_method,
                'payment_status' => $order->payment_status,
                'delivery_address' => $order->deliveryAddress,
                'special_instructions' => $order->special_instructions,
                'created_at' => $order->created_at,
                'estimated_delivery_time' => $order->estimated_delivery_time,
            ]
        ]);
    }

    /**
     * Get user's orders
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Order::where('user_id', $user->id);

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        // Order by newest first
        $query->orderBy('created_at', 'desc');

        // Pagination
        $perPage = $request->get('per_page', 15);
        $orders = $query->paginate($perPage);

        return response()->json([
            'data' => $orders->items(),
            'meta' => [
                'current_page' => $orders->currentPage(),
                'last_page' => $orders->lastPage(),
                'per_page' => $orders->perPage(),
                'total' => $orders->total(),
            ]
        ]);
    }
}
