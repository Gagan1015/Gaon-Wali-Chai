<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AddressController extends Controller
{
    /**
     * Get all user addresses
     */
    public function index()
    {
        $user = request()->user();
        
        $addresses = Address::where('user_id', $user->id)
            ->orderBy('is_default', 'desc')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'data' => $addresses
        ]);
    }

    /**
     * Create a new address
     */
    public function store(Request $request)
    {
        $request->validate([
            'label' => 'required|string|max:50',
            'address_line1' => 'required|string|max:255',
            'address_line2' => 'nullable|string|max:255',
            'city' => 'required|string|max:100',
            'state' => 'required|string|max:100',
            'pincode' => 'required|string|max:20',
            'is_default' => 'nullable|boolean',
        ]);

        $user = $request->user();

        DB::beginTransaction();
        try {
            // If this is set as default, remove default from other addresses
            if ($request->get('is_default', false)) {
                Address::where('user_id', $user->id)
                    ->update(['is_default' => false]);
            }

            $address = Address::create([
                'user_id' => $user->id,
                'label' => $request->label,
                'address_line1' => $request->address_line1,
                'address_line2' => $request->address_line2,
                'city' => $request->city,
                'state' => $request->state,
                'pincode' => $request->pincode,
                'is_default' => $request->get('is_default', false),
            ]);

            DB::commit();

            return response()->json([
                'message' => 'Address created successfully',
                'data' => $address
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to create address',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get a single address
     */
    public function show($id)
    {
        $user = request()->user();
        
        $address = Address::where('user_id', $user->id)
            ->where('id', $id)
            ->firstOrFail();

        return response()->json([
            'data' => $address
        ]);
    }

    /**
     * Update an address
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'label' => 'nullable|string|max:50',
            'address_line1' => 'nullable|string|max:255',
            'address_line2' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:100',
            'state' => 'nullable|string|max:100',
            'pincode' => 'nullable|string|max:20',
            'is_default' => 'nullable|boolean',
        ]);

        $user = $request->user();

        $address = Address::where('user_id', $user->id)
            ->where('id', $id)
            ->firstOrFail();

        DB::beginTransaction();
        try {
            // If setting as default, remove default from other addresses
            if ($request->has('is_default') && $request->is_default) {
                Address::where('user_id', $user->id)
                    ->where('id', '!=', $id)
                    ->update(['is_default' => false]);
            }

            $address->update($request->only([
                'label',
                'address_line1',
                'address_line2',
                'city',
                'state',
                'pincode',
                'is_default',
            ]));

            DB::commit();

            return response()->json([
                'message' => 'Address updated successfully',
                'data' => $address
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => 'Failed to update address',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Delete an address
     */
    public function destroy($id)
    {
        $user = request()->user();
        
        $address = Address::where('user_id', $user->id)
            ->where('id', $id)
            ->firstOrFail();

        $address->delete();

        return response()->json([
            'message' => 'Address deleted successfully'
        ]);
    }
}
