<?php

namespace App\Repositories;

class UsuarioRepository extends BaseRepository
{
    public function __construct()
    {
        parent::__construct('usuarios');
    }
}
