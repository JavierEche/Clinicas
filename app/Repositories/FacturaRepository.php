<?php

namespace App\Repositories;

class FacturaRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('facturas');
    }
}
