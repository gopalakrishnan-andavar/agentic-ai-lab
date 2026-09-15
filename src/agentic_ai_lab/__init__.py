"""agentic-ai-lab — 10-day plan, 14-23 Sep 2026."""

def add_alert(alert, batch=[]):
    batch.append(alert)
    return batch

print(add_alert("A1"))
print(add_alert("A2"))
print(add_alert.__defaults__)