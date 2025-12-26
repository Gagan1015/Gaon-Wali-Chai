<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * Get all active categories
     */
    public function index()
    {
        $categories = Category::where('is_active', true)
            ->orderBy('sort_order')
            ->orderBy('name')
            ->get();

        return response()->json([
            'data' => $categories
        ]);
    }

    /**
     * Get a single category
     */
    public function show($id)
    {
        $category = Category::where('is_active', true)
            ->findOrFail($id);

        return response()->json([
            'data' => $category
        ]);
    }
}
