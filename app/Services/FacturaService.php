<?php

namespace App\Services;

use App\Repositories\FacturaRepository;

class FacturaService extends BaseCrudService
{
    public function __construct(FacturaRepository $repository)
    {
        parent::__construct($repository);
    }
}
