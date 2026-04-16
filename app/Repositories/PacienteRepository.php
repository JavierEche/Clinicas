<?php

namespace App\Repositories;

class PacienteRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('pacientes');
    }
}
