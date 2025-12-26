<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductVariant extends Model
{
    protected $fillable = [
        'product_id',
        'name',
        'price',
        'image',
        'is_available',
    ];

    protected $casts = [
        'id' => 'integer',
        'product_id' => 'integer',
        'price' => 'float',
        'is_available' => 'boolean',
    ];

    // Relationships
    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function cartItemVariants()
    {
        return $this->hasMany(CartItemVariant::class, 'variant_id');
    }
}
