<?php

namespace App\Services;

use App\Repositories\UsuarioRepository;

class UsuarioService extends BaseCrudService
{
    public function __construct(UsuarioRepository $repository)
    {
        parent::__construct($repository);
    }
}
