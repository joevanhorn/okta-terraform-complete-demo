# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to: security@example.com

You should receive a response within 48 hours. If for some reason you do not, please follow up to ensure we received your original message.

Please include the following information:

- Type of issue (e.g. buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit the issue

## Security Best Practices

### Credentials
- Never commit API tokens, passwords, or secrets to the repository
- Use GitHub Secrets for CI/CD credentials
- Rotate API tokens regularly (every 90 days)
- Use least privilege principle for API tokens

### Terraform State
- Always encrypt state files
- Use remote backend with encryption
- Enable state locking
- Restrict access to state storage

### API Management
- Review all API operations before execution
- Enable audit logging
- Monitor for suspicious activity
- Validate all inputs


