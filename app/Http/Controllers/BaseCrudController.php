<?php

namespace App\Http\Controllers;

use App\Services\BaseCrudService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class BaseCrudController extends Controller
{
    public function __construct(
        protected BaseCrudService $service,
        protected string $viewFolder,
        protected array $fields,
        protected string $routeName
    ) {
    }

    public function index(): View
    {
        return view("{$this->viewFolder}.index", [
            'rows' => $this->service->listar(),
            'fields' => $this->fields,
            'routeName' => $this->routeName,
            'titulo' => ucfirst(str_replace('_', ' ', $this->viewFolder)),
        ]);
    }

    public function create(): View
    {
        return view("{$this->viewFolder}.create", [
            'fields' => $this->fields,
            'routeName' => $this->routeName,
            'titulo' => ucfirst(str_replace('_', ' ', $this->viewFolder)),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $payload = $request->only($this->fields);
        $this->service->crear($payload);

        return redirect()
            ->route("{$this->routeName}.index")
            ->with('ok', 'Registro creado correctamente.');
    }
}
