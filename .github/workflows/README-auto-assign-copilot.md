# Auto-assign Copilot Workflow

## Overview

The `auto-assign-copilot.yml` workflow automatically assigns GitHub Copilot to issues that are intended for AI assistance. This helps streamline the process of directing AI-appropriate tasks to the right assignee.

## How It Works

### Trigger
The workflow runs automatically when a new issue is opened in the repository.

### Conditions
An issue is considered a "Copilot task" if **either** of these conditions is met:

1. **Title prefix**: Issue title starts with `[Copilot]: `
2. **Label**: Issue has the `robot :robot:` label

### Assignment Logic

1. **Primary attempt**: Try to assign `Copilot` (the GitHub Copilot app)
2. **Fallback**: If the primary assignment fails, assign `rempsyc` instead
3. **Error handling**: If both assignments fail, the workflow fails with an error message

### Example Scenarios

#### ✅ Successful Cases

**Case 1: Title-based detection**
```
Title: "[Copilot]: Fix bug in data processing function"
Labels: (any labels)
Result: Assigns Copilot
```

**Case 2: Label-based detection**
```
Title: "Need help with statistical analysis"
Labels: ["robot :robot:", "help wanted"]
Result: Assigns Copilot
```

**Case 3: Both conditions met**
```
Title: "[Copilot]: Automated code review"
Labels: ["robot :robot:"]
Result: Assigns Copilot
```

#### ⏭️ Skipped Cases

**Case 1: Neither condition met**
```
Title: "Update documentation"
Labels: ["documentation"]
Result: No assignment (workflow skips)
```

## Workflow Logs

The improved workflow provides detailed logging with visual indicators:

```
🤖 Auto-assign Copilot workflow started
📋 Issue #123: "[Copilot]: Test new feature"
🏷️  Labels: robot :robot:, enhancement
🔍 Title starts with "[Copilot]: ": true
🔍 Has "robot :robot:" label: true
✅ Is Copilot task: true
🎯 Attempting to assign Copilot to the issue...
✅ Successfully assigned Copilot to the issue!
🏁 Auto-assign Copilot workflow completed
```

## Testing the Workflow

### Manual Testing Steps

1. **Create a test issue** with either:
   - Title starting with `[Copilot]: ` 
   - Or add the `robot :robot:` label

2. **Check the Actions tab** to see the workflow run

3. **Review the logs** for detailed execution feedback

4. **Verify assignment** by checking if Copilot (or fallback assignee) was assigned

### Expected Behaviors

- ✅ Issues matching criteria should be assigned to Copilot
- ⏭️ Issues not matching criteria should be skipped (no assignment)
- 🔄 If Copilot assignment fails, fallback to `rempsyc`
- 📝 All actions should be clearly logged with emojis for easy reading

## Troubleshooting

### Common Issues

**Workflow doesn't run**
- Check that the workflow file is in `.github/workflows/`
- Verify the workflow has proper YAML syntax
- Ensure repository has Actions enabled

**Assignment fails**
- Check repository permissions for the GitHub token
- Verify `issues: write` permission is granted
- Review error messages in workflow logs

**Fallback assignment fails**
- Check that fallback user (`rempsyc`) has access to the repository
- Verify user exists and is spelled correctly

### Debug Information

The workflow logs provide comprehensive information for debugging:
- Issue details (number, title, labels)
- Condition evaluation results
- Assignment attempt outcomes
- Error messages with specific failure reasons

## Customization

To customize the workflow for different repositories:

1. **Change detection criteria**: Modify the `titleMatches` and `labelMatches` conditions
2. **Update fallback assignee**: Change `rempsyc` to your preferred fallback user
3. **Add additional conditions**: Extend the `isCopilotTask` logic as needed

## Security Considerations

- The workflow only has `issues: write` permission (minimal required access)
- Assignment actions are logged for transparency
- Fallback assignment prevents workflow failures from blocking issue creation