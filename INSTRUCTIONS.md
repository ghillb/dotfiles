# Development Guidelines

## Code Style & Structure

### Simplicity First
- Write code that's immediately understandable to others
- Avoid premature optimization
- Question every feature: "Is this really necessary?"
- Keep dependencies minimal but practical
- If you can't explain your code simply, it's probably too complex

### File Structure
- Keep files under 200-300 lines of code
- Group related code together
- Maintain a flat structure where possible
- Group by feature rather than type
- Use consistent indentation (2 or 4 spaces)
- Add spacing between logical sections

### Naming & Code Organization
- Use descriptive, meaningful names for variables, functions, and classes
- Use type hints whenever possible
- Avoid deep nesting of conditionals
- No docstrings or comments unless absolutely necessary for explaining the why
- Keep functions short (typically under 20 lines)
- Limit function parameters (3 or fewer is ideal)

### Error Handling
- Handle potential errors explicitly
- Validate input data
- Return meaningful error messages
- Never mock data for dev or prod environments
- Never add stubbing or fake data patterns outside of tests

## Development Workflow

### Task Management
- Focus on areas of code relevant to the task
- Do not touch code unrelated to the task
- Write thorough tests for all major functionality
- Make scripts executable
- Avoid writing one-off scripts in files when possible

### Environment Considerations
- Write code that accounts for dev, test, and prod environments
- Never overwrite .env file without first asking and confirming
- Mocking data is only needed for tests
- Consider impact on all environments when making changes

### Change Management
- Exhaust existing implementation options before introducing new patterns
- Remove old implementations when introducing new ones
- Consider what other methods might be affected by changes
- Avoid major architectural changes unless explicitly instructed

## Object-Oriented Programming

### Core Principles
1. Single Responsibility
```python
# Good
class UserRepository:
    def save_user(self, user): ...

class EmailService:
    def send_email(self, user): ...
```

2. Explicit Dependencies
```python
class OrderService:
    def __init__(self, email_service):
        self.email_service = email_service
        
    def process_order(self, order):
        self.email_service.send_confirmation(order)
```

3. Composition Over Inheritance
```python
class SupermarketItem:
    def __init__(self):
        self.electronic = ElectronicProperties()
        self.perishable = PerishableProperties()
        self.tax = TaxProperties()
```

### Best Practices
- Initialize all attributes in constructor
- Use strong types and interface contracts
- Keep methods focused on single responsibility
- Use private attributes and public methods judiciously
- Make dependencies explicit through injection

### Anti-Patterns to Avoid
- God Classes (doing too much)
- Feature Envy (overusing other classes' features)
- Long Parameter Lists
- Tight Coupling
- Premature Optimization

## Debugging Process

### Systematic Approach
1. Identify Symptoms
- Understand incorrect behavior
- Document reported errors
- Replicate the issue

2. Isolate the Problem
- Reproduce in controlled environment
- Minimize steps to trigger
- Understand system components involved

3. Fix and Verify
- Form and test hypotheses
- Validate input/output
- Confirm fix in all environments

### Testing Guidelines
- Write tests first (TDD) when possible
- Test public interfaces, not implementation details
- Use meaningful test names
- Keep tests independent
- Test edge cases and error conditions
