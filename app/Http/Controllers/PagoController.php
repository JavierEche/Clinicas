<?php

namespace App\Http\Controllers;

use App\Services\PagoService;

class PagoController extends BaseCrudController
{
    public function __construct(PagoService $service)
    {
        parent::__construct(
            $service,
            'pagos',
            explode(',', 'factura_id,metodo_pago_id,fecha_pago,monto,numero_referencia,codigo_transaccion,estado,recibido_por,observaciones'),
            'pagos'
        );
    }
}
