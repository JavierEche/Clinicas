<?php

namespace App\Repositories;

class CitaMedicaRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('citas_medicas');
    }
}
