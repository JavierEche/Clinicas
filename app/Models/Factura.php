<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Factura extends Model
{
    protected $table = 'facturas';

    protected $fillable = [
        'numero_factura',
        'paciente_id',
        'atencion_id',
        'fecha_emision',
        'subtotal',
        'descuento',
        'impuesto',
        'total',
        'saldo_pendiente',
        'estado',
        'emitida_por',
    ];

    public const CREATED_AT = 'creado_en';
    public const UPDATED_AT = 'actualizado_en';
}
