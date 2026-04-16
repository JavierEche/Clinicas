<?php

namespace App\Services;

use App\Repositories\PacienteRepository;

class PacienteService extends BaseCrudService
{
    public function __construct(PacienteRepository $repository)
    {
        parent::__construct($repository);
    }
}
