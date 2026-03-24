#!/usr/bin/env python3

import socket


class RedisError(RuntimeError):
    pass


class RedisClient:
    def __init__(self, server=None, sock_path=None):
        if server is None and sock_path is None:
            server = ("localhost", 6379)
        self.server = server
        self.sock_path = sock_path
        self._sock = None
        self._file = None

    def close(self):
        if self._file is not None:
            self._file.close()
            self._file = None
        if self._sock is not None:
            self._sock.close()
            self._sock = None

    def _connect(self):
        if self._sock is not None:
            return
        if self.sock_path is not None:
            self._sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            self._sock.connect(self.sock_path)
        else:
            host, port = self.server
            self._sock = socket.create_connection((host, port))
        self._file = self._sock.makefile("rb")

    @staticmethod
    def _encode_part(value):
        if isinstance(value, bytes):
            data = value
        else:
            data = str(value).encode("utf-8")
        return b"$" + str(len(data)).encode("ascii") + b"\r\n" + data + b"\r\n"

    def _write_command(self, *parts):
        self._connect()
        payload = [b"*" + str(len(parts)).encode("ascii") + b"\r\n"]
        payload.extend(self._encode_part(part) for part in parts)
        self._sock.sendall(b"".join(payload))

    def _read_line(self):
        line = self._file.readline()
        if not line:
            raise RedisError("unexpected EOF from Redis")
        if not line.endswith(b"\r\n"):
            raise RedisError(f"malformed Redis reply: {line!r}")
        return line[:-2]

    @staticmethod
    def _decode_bulk(data):
        return data.decode("utf-8", "replace")

    def _read_reply(self):
        prefix = self._file.read(1)
        if not prefix:
            raise RedisError("unexpected EOF from Redis")
        if prefix == b"+":
            return self._decode_bulk(self._read_line())
        if prefix == b"-":
            raise RedisError(self._decode_bulk(self._read_line()))
        if prefix == b":":
            return int(self._read_line())
        if prefix == b"$":
            length = int(self._read_line())
            if length == -1:
                return None
            data = self._file.read(length)
            tail = self._file.read(2)
            if len(data) != length or tail != b"\r\n":
                raise RedisError("truncated bulk reply from Redis")
            return self._decode_bulk(data)
        if prefix == b"*":
            length = int(self._read_line())
            if length == -1:
                return None
            return [self._read_reply() for _ in range(length)]
        raise RedisError(f"unsupported Redis reply prefix: {prefix!r}")

    def command(self, *parts):
        self._write_command(*parts)
        return self._read_reply()

    def ping(self):
        return self.command("PING")

    def keys(self, pattern):
        result = self.command("KEYS", pattern)
        return [] if result is None else result

    def hgetall(self, key):
        result = self.command("HGETALL", key)
        if result is None:
            return {}
        if len(result) % 2 != 0:
            raise RedisError(f"malformed HGETALL result for {key!r}: {result!r}")
        return {result[i]: result[i + 1] for i in range(0, len(result), 2)}

    def hmget(self, key, *fields):
        result = self.command("HMGET", key, *fields)
        return [] if result is None else result

    def hset(self, key, mapping):
        parts = ["HSET", key]
        for field, value in mapping.items():
            parts.extend([field, value])
        return self.command(*parts)

    def dbsize(self):
        return self.command("DBSIZE")
