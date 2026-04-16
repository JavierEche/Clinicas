<?php

namespace App\Services;

use App\Repositories\MedicoRepository;

class MedicoService extends BaseCrudService
{
    public function __construct(MedicoRepository $repository)
    {
        parent::__construct($repository);
    }
}
