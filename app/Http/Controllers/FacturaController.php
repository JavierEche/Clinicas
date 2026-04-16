<?php

namespace App\Http\Controllers;

use App\Services\FacturaService;

class FacturaController extends BaseCrudController
{
    public function __construct(FacturaService $service)
    {
        parent::__construct(
            $service,
            'facturas',
            explode(',', 'numero_factura,paciente_id,atencion_id,fecha_emision,subtotal,descuento,impuesto,total,saldo_pendiente,estado,emitida_por'),
            'facturas'
        );
    }
}
