<?php

namespace App\Repositories;

class PagoRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('pagos');
    }
}
