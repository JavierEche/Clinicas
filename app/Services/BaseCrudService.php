<?php

namespace App\Services;

use App\Repositories\BaseRepository;

class BaseCrudService
{
    public function __construct(protected BaseRepository $repository)
    {
    }

    public function listar(int $limit = 100)
    {
        return $this->repository->all($limit);
    }

    public function crear(array $data): int
    {
        return $this->repository->create($data);
    }
}
