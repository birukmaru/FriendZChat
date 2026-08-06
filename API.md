# API Reference (mock contract)

The FriendZChat client talks to a small REST surface. The endpoints below
are what `ApiServiceImpl(Dio)` calls. `MockApiService` honours the same
shapes so the UI is fully functional without a backend.

> Base URL is configurable in `lib/core/constants/app_constants.dart`.

---

## POST /register

Register (or update) a user.

**Request**

```json
{
  "userId": "123456",
  "nickname": "Ada",
  "phoneNumber": "+14155552671"
}
```

**Response 200**

```json
{
  "id": "123456",
  "nickname": "Ada",
  "phoneNumber": "+14155552671",
  "isVerified": true,
  "createdAt": "2026-08-03T09:00:00Z"
}
```

**Errors**

- `400` – invalid ID format.
- `409` – ID already registered to a different phone.
- `5xx` – transient.

---

## GET /profile

Returns the authenticated user's profile.

**Response 200**

```json
{
  "id": "123456",
  "nickname": "Ada",
  "photoUrl": null,
  "phoneNumber": "+14155552671",
  "email": null,
  "bio": null,
  "createdAt": "2026-08-01T09:00:00Z",
  "lastSeen": "2026-08-03T08:55:00Z",
  "isVerified": true
}
```

---

## PUT /profile/update

Update the profile.

**Request** — full profile object.

**Response 200** — same shape as above.

---

## POST /auth/otp

Request an OTP for the given phone number.

**Request**

```json
{ "phoneNumber": "+14155552671" }
```

**Response 202** — empty body. Mock implementation always succeeds.

---

## POST /auth/verify

Verify an OTP.

**Request**

```json
{ "phoneNumber": "+14155552671", "otp": "123456" }
```

**Response 200** — UserDto (same shape as `/register`).

Mock implementation accepts `123456` only.

---

## POST /auth/logout

Invalidate the current session token.

---

## POST /call (REST transport only)

Used by `RestCallService` to register a call intent. Not used by the
default dialer transport.

**Request**

```json
{ "to": "987654", "from": "123456" }
```

---

## Notes

- All requests must carry `Authorization: Bearer <token>` once the user
  has authenticated (the Dio client adds this automatically).
- Errors use the shape:

```json
{ "code": "INVALID_ID", "message": "..." }
```

- The client wraps any non-2xx response into a `ServerFailure`.