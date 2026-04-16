<?php

namespace App\Services;

use App\Repositories\PagoRepository;

class PagoService extends BaseCrudService
{
    public function __construct(PagoRepository $repository)
    {
        parent::__construct($repository);
    }
}
