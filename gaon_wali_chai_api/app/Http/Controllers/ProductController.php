<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Get all products with optional filters
     */
    public function index(Request $request)
    {
        $query = Product::with(['category', 'sizes', 'variants'])
            ->where('is_available', true);

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Filter by featured
        if ($request->has('featured')) {
            $query->where('is_featured', filter_var($request->featured, FILTER_VALIDATE_BOOLEAN));
        }

        // Search by name
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        // Order by sort_order and name
        $query->orderBy('sort_order')->orderBy('name');

        // Pagination
        $perPage = $request->get('per_page', 15);
        $products = $query->paginate($perPage);

        return response()->json([
            'data' => $products->items(),
            'meta' => [
                'current_page' => $products->currentPage(),
                'last_page' => $products->lastPage(),
                'per_page' => $products->perPage(),
                'total' => $products->total(),
            ]
        ]);
    }

    /**
     * Get a single product with details
     */
    public function show($id)
    {
        $product = Product::with(['category', 'sizes', 'variants'])
            ->where('is_available', true)
            ->findOrFail($id);

        return response()->json([
            'data' => $product
        ]);
    }
}
