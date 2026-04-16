<?php

namespace App\Services;

use App\Repositories\CitaMedicaRepository;

class CitaMedicaService extends BaseCrudService
{
    public function __construct(CitaMedicaRepository $repository)
    {
        parent::__construct($repository);
    }
}
