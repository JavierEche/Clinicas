@extends('layouts.app')

@section('content')
<div class="container">
    <h1>{{ $titulo }}</h1>

    @if (session('ok'))
        <div class="alert alert-success">{{ session('ok') }}</div>
    @endif

    <a href="{{ route($routeName . '.create') }}" class="btn btn-primary mb-3">Nuevo registro</a>

    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    @foreach ($fields as $field)
                        <th>{{ $field }}</th>
                    @endforeach
                </tr>
            </thead>
            <tbody>
                @forelse ($rows as $row)
                    <tr>
                        <td>{{ $row->id }}</td>
                        @foreach ($fields as $field)
                            <td>{{ $row->{$field} ?? '' }}</td>
                        @endforeach
                    </tr>
                @empty
                    <tr>
                        <td colspan="{{ count($fields) + 1 }}">Sin registros.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection
