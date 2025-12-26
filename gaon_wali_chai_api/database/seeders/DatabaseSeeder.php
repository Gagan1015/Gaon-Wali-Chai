<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Product;
use App\Models\ProductSize;
use App\Models\ProductVariant;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create categories
        $hotDrinks = Category::create([
            'name' => 'Kulhad Tea',
            'icon' => 'https://via.placeholder.com/100',
            'sort_order' => 1,
        ]);

        $snacks = Category::create([
            'name' => 'Snacks',
            'icon' => 'https://via.placeholder.com/100',
            'sort_order' => 2,
        ]);

        $desserts = Category::create([
            'name' => 'Desserts',
            'icon' => 'https://via.placeholder.com/100',
            'sort_order' => 3,
        ]);

        $shakes = Category::create([
            'name' => 'Shakes',
            'icon' => 'https://via.placeholder.com/100',
            'sort_order' => 4,
        ]);

        // Create products for Kulhad Tea
        $kulhadChai = Product::create([
            'category_id' => $hotDrinks->id,
            'name' => 'Kulhad Chai',
            'description' => 'Traditional Indian tea served in earthen kulhad',
            'base_price' => 50,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => true,
            'is_available' => true,
            'sort_order' => 1,
        ]);

        // Sizes for Kulhad Chai
        ProductSize::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Small',
            'price' => 50,
        ]);

        ProductSize::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Medium',
            'price' => 70,
        ]);

        ProductSize::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Large',
            'price' => 90,
        ]);

        // Variants for Kulhad Chai
        ProductVariant::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Extra Sugar',
            'price' => 5,
            'image' => 'https://via.placeholder.com/100',
        ]);

        ProductVariant::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Elaichi',
            'price' => 10,
            'image' => 'https://via.placeholder.com/100',
        ]);

        ProductVariant::create([
            'product_id' => $kulhadChai->id,
            'name' => 'Ginger',
            'price' => 10,
            'image' => 'https://via.placeholder.com/100',
        ]);

        // Masala Chai
        $masalaChai = Product::create([
            'category_id' => $hotDrinks->id,
            'name' => 'Masala Chai',
            'description' => 'Spiced Indian tea with aromatic masala blend',
            'base_price' => 60,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => true,
            'is_available' => true,
            'sort_order' => 2,
        ]);

        // Sizes for Masala Chai
        ProductSize::create([
            'product_id' => $masalaChai->id,
            'name' => 'Small',
            'price' => 60,
        ]);

        ProductSize::create([
            'product_id' => $masalaChai->id,
            'name' => 'Medium',
            'price' => 80,
        ]);

        ProductSize::create([
            'product_id' => $masalaChai->id,
            'name' => 'Large',
            'price' => 100,
        ]);

        // Snacks
        $samosa = Product::create([
            'category_id' => $snacks->id,
            'name' => 'Samosa',
            'description' => 'Crispy fried pastry with spiced potato filling',
            'base_price' => 20,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => true,
            'is_available' => true,
            'sort_order' => 1,
        ]);

        ProductSize::create([
            'product_id' => $samosa->id,
            'name' => 'Regular',
            'price' => 20,
        ]);

        ProductVariant::create([
            'product_id' => $samosa->id,
            'name' => 'Extra Chutney',
            'price' => 5,
            'image' => 'https://via.placeholder.com/100',
        ]);

        // Pakora
        $pakora = Product::create([
            'category_id' => $snacks->id,
            'name' => 'Pakora',
            'description' => 'Mixed vegetable fritters',
            'base_price' => 30,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => false,
            'is_available' => true,
            'sort_order' => 2,
        ]);

        ProductSize::create([
            'product_id' => $pakora->id,
            'name' => 'Regular',
            'price' => 30,
        ]);

        // Desserts
        $gulabjamun = Product::create([
            'category_id' => $desserts->id,
            'name' => 'Gulab Jamun',
            'description' => 'Sweet milk-based dumpling in sugar syrup',
            'base_price' => 40,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => false,
            'is_available' => true,
            'sort_order' => 1,
        ]);

        ProductSize::create([
            'product_id' => $gulabjamun->id,
            'name' => '2 Pieces',
            'price' => 40,
        ]);

        ProductSize::create([
            'product_id' => $gulabjamun->id,
            'name' => '4 Pieces',
            'price' => 70,
        ]);

        // Shakes
        $mangoShake = Product::create([
            'category_id' => $shakes->id,
            'name' => 'Mango Shake',
            'description' => 'Refreshing mango flavored milkshake',
            'base_price' => 80,
            'image' => 'https://via.placeholder.com/300',
            'is_featured' => true,
            'is_available' => true,
            'sort_order' => 1,
        ]);

        ProductSize::create([
            'product_id' => $mangoShake->id,
            'name' => 'Regular',
            'price' => 80,
        ]);

        ProductSize::create([
            'product_id' => $mangoShake->id,
            'name' => 'Large',
            'price' => 100,
        ]);

        ProductVariant::create([
            'product_id' => $mangoShake->id,
            'name' => 'Extra Thick',
            'price' => 15,
            'image' => 'https://via.placeholder.com/100',
        ]);

        ProductVariant::create([
            'product_id' => $mangoShake->id,
            'name' => 'Less Sugar',
            'price' => 0,
            'image' => 'https://via.placeholder.com/100',
        ]);
    }
}

