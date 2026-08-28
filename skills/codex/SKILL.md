---
name: codex
description: Use OpenAI Codex CLI as a second opinion for complex debugging, code analysis, and technical questions. Invoke when stuck on subtle bugs, algorithm issues, or spec compliance problems.
---

# How to Use Codex from Claude Code

Codex is an AI-powered CLI tool that can help with complex debugging, code analysis, and technical questions. When you encounter difficult problems that would benefit from a second perspective or deep analysis, use Codex.

## When to Use Codex

- Debugging subtle bugs (e.g., bitstream alignment issues, off-by-one errors)
- Analyzing complex algorithms against specifications
- Getting a detailed code review with specific bug identification
- Understanding obscure file formats or protocols
- When you've tried multiple approaches and are stuck

## The File-Based Pattern

Codex works best with a file-based input/output pattern:

### Step 1: Create a Question File

Write your question and all relevant context to `/tmp/question.txt`:

```
Write to /tmp/question.txt:
- Clear problem statement
- The specific error or symptom
- The relevant code (full functions, not snippets)
- What you've already tried
- Specific questions you want answered
```

Example structure:
```
I have a [component] that fails with [specific error].

Here is the full function:
```c
[paste complete code]
```

Key observations:
1. [What works]
2. [What fails]
3. [When it fails]

Can you identify:
1. [Specific question 1]
2. [Specific question 2]

Please write a detailed analysis to /tmp/reply.txt
```

### Step 2: Invoke Codex

Use this command pattern:

```bash
cat /tmp/question.txt | codex exec -o /tmp/reply.txt --full-auto
```

Flags:
- `exec`: Non-interactive execution mode (required for CLI use)
- `-o /tmp/reply.txt`: Write output to this file
- `--full-auto`: Run autonomously without prompts

### Step 3: Read the Reply

```bash
Read /tmp/reply.txt
```

Codex will provide detailed analysis. Evaluate its suggestions critically - it may identify real bugs but can occasionally misinterpret specifications.

## Example Session

```
# 1. Create the question
Write /tmp/question.txt with:
- Problem: "Progressive JPEG decoder fails at block 1477 with Huffman error"
- Code: [full AC refinement function]
- Questions: "Identify bugs in EOB handling, ZRL handling, run counting"

# 2. Invoke Codex
cat /tmp/question.txt | codex exec -o /tmp/reply.txt --full-auto

# 3. Read and apply
Read /tmp/reply.txt
# Codex identified 12 potential bugs with detailed explanations
# Evaluate each, verify against spec, apply fixes
```

## Tips

1. **Provide complete code**: Don't truncate functions. Codex needs full context.

2. **Be specific**: "Why does this fail?" is worse than "Why does Huffman decoding fail after processing 1477 blocks in AC refinement scan?"

3. **Include the spec**: If debugging against a standard (JPEG, PNG, etc.), mention the relevant spec sections.

4. **Verify suggestions**: Codex is helpful but not infallible. In one session, it incorrectly identified the EOB run formula as buggy when it was actually correct. Always verify against authoritative sources.

5. **Iterate if needed**: If the first response doesn't solve the problem, create a new question.txt with additional context from what you learned.

## Common Issues

**"stdin is not a terminal"**: Use `codex exec` not bare `codex`

**No output**: Check that `-o` flag has a valid path

**Timeout**: For very complex questions, Codex may take time. The `--full-auto` flag helps avoid interactive prompts that would block.

## Alternative: Direct Piping

For shorter questions:
```bash
echo "Explain the JPEG progressive AC refinement algorithm" | codex exec --full-auto
```

But for debugging, the file-based pattern is better because you can refine the question and keep a record.
