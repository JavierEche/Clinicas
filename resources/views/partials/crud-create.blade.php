@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Nuevo {{ $titulo }}</h1>

    <form method="POST" action="{{ route($routeName . '.store') }}">
        @csrf

        @foreach ($fields as $field)
            <div class="mb-3">
                <label class="form-label" for="{{ $field }}">{{ $field }}</label>
                <input
                    type="text"
                    id="{{ $field }}"
                    name="{{ $field }}"
                    value="{{ old($field) }}"
                    class="form-control"
                >
            </div>
        @endforeach

        <button type="submit" class="btn btn-success">Guardar</button>
        <a href="{{ route($routeName . '.index') }}" class="btn btn-secondary">Volver</a>
    </form>
</div>
@endsection
