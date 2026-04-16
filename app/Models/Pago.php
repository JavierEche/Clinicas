<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pago extends Model
{
    protected $table = 'pagos';

    protected $fillable = [
        'factura_id',
        'metodo_pago_id',
        'fecha_pago',
        'monto',
        'numero_referencia',
        'codigo_transaccion',
        'estado',
        'recibido_por',
        'observaciones',
    ];

    public const CREATED_AT = 'creado_en';
    public const UPDATED_AT = 'actualizado_en';
}
