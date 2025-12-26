<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartItemVariant extends Model
{
    protected $fillable = [
        'cart_item_id',
        'variant_id',
    ];

    // Relationships
    public function cartItem()
    {
        return $this->belongsTo(CartItem::class);
    }

    public function variant()
    {
        return $this->belongsTo(ProductVariant::class, 'variant_id');
    }
}
