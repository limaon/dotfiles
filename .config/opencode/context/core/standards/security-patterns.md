# Security Patterns

## Input & Output

- Validate and sanitize all user input
- Prevent SQL injection (prepared statements), XSS (output sanitization)
- Prevent path traversal

## Authentication & Authorization

- JWT: manage refresh tokens with rotation; never log tokens
- RBAC for access control
- Principle of least privilege

## Secrets

- Never hardcode keys/passwords in code
- Use environment variables or a secrets manager
- Never commit sensitive data

## Configuration

- Logs without sensitive data (PII, tokens, credentials)
- Security headers (CSP, HSTS, etc.) on the frontend
- Keep dependencies up-to-date (avoid known CVEs)
