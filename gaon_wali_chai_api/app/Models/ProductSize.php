<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductSize extends Model
{
    protected $fillable = [
        'product_id',
        'name',
        'price',
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

    public function cartItems()
    {
        return $this->hasMany(CartItem::class, 'size_id');
    }
}
