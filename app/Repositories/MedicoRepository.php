<?php

namespace App\Repositories;

class MedicoRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('medicos');
    }
}
