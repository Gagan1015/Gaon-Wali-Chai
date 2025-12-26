<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    protected $fillable = [
        'order_id',
        'product_id',
        'product_name',
        'product_image',
        'size_name',
        'size_price',
        'quantity',
        'item_total',
    ];

    protected $casts = [
        'size_price' => 'decimal:2',
        'quantity' => 'integer',
        'item_total' => 'decimal:2',
    ];

    // Relationships
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function variants()
    {
        return $this->hasMany(OrderItemVariant::class);
    }
}
