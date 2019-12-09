@extends('layouts.app')

@section('content')
    <form method="post" action="{{ route('room', ['roomId' => $roomId]) }}">
        @csrf
        ニックネーム: <input type="text" name="username">
        <button type="submit">ジョイン</button>
    </form>
@endsection