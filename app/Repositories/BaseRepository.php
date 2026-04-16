<?php

namespace App\Repositories;

use Illuminate\Support\Facades\DB;

class BaseRepository
{
    public function __construct(protected string $table)
    {
    }

    public function all(int $limit = 100)
    {
        return DB::table($this->table)->latest('id')->limit($limit)->get();
    }

    public function create(array $data): int
    {
        return (int) DB::table($this->table)->insertGetId($data);
    }
}
