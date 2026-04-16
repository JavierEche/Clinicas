<?php

namespace App\Services;

use App\Repositories\EspecialidadRepository;

class EspecialidadService extends BaseCrudService
{
    public function __construct(EspecialidadRepository $repository)
    {
        parent::__construct($repository);
    }
}
