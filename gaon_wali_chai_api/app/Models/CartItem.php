<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CartItem extends Model
{
    protected $fillable = [
        'user_id',
        'product_id',
        'size_id',
        'quantity',
    ];

    protected $casts = [
        'quantity' => 'integer',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function size()
    {
        return $this->belongsTo(ProductSize::class, 'size_id');
    }

    public function variants()
    {
        return $this->hasMany(CartItemVariant::class);
    }

    // Helper methods
    public function calculateTotal()
    {
        $total = $this->size->price * $this->quantity;
        
        // Add variants price
        foreach ($this->variants as $cartVariant) {
            $total += $cartVariant->variant->price * $this->quantity;
        }
        
        return $total;
    }
}
