<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItemVariant extends Model
{
    protected $fillable = [
        'order_item_id',
        'variant_name',
        'variant_price',
    ];

    protected $casts = [
        'variant_price' => 'decimal:2',
    ];

    // Relationships
    public function orderItem()
    {
        return $this->belongsTo(OrderItem::class);
    }
}
