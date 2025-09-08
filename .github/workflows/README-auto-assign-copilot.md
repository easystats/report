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

The workflow now tests multiple Copilot username variants to ensure reliable assignment:

1. **Primary attempt**: Try to assign `Copilot` (uppercase - matches official bot login)
2. **Fallback 1**: Try to assign `copilot` (lowercase - previous working approach)  
3. **Fallback 2**: Try to assign `github-copilot` (as suggested for alternative accounts)
4. **Final fallback**: If all Copilot variants fail, assign `rempsyc` instead
5. **Verification**: Check that assignment actually took effect via API verification
6. **Error handling**: If all assignments fail, the workflow fails with detailed error messages

**New in v2**: The workflow now includes comprehensive testing of different Copilot usernames and verification of successful assignment.

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
👤 Issue author: testuser
🏠 Repository: easystats/report
🔍 Title starts with "[Copilot]: ": true
🔍 Has "robot :robot:" label: true
✅ Is Copilot task: true
🎯 Attempting to assign Copilot to the issue...
✅ Successfully assigned copilot to the issue!
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

- ✅ Issues matching criteria should be assigned to Copilot (testing multiple username variants)
- 🔍 Workflow tests `Copilot`, `copilot`, and `github-copilot` usernames automatically  
- ✅ Assignment is verified via API to confirm it took effect
- ⏭️ Issues not matching criteria should be skipped (no assignment)
- 🔄 If all Copilot variants fail, fallback to `rempsyc`
- 📝 All actions should be clearly logged with emojis for easy reading
- 🔍 Detailed error information provided when assignments fail
- ⏰ Assignment happens within ~3 seconds of issue creation (may not be visible immediately in UI)

## Troubleshooting

### Common Issues

**Workflow doesn't run**
- Check that the workflow file is in `.github/workflows/`
- Verify the workflow has proper YAML syntax
- Ensure repository has Actions enabled

**Assignment appears to fail but Copilot is actually assigned**
- **This is the most common "issue"** - assignment actually works but timing confusion occurs
- Check the issue assignees via API or refresh the GitHub web interface  
- Assignment happens ~3 seconds after issue creation (user may write "not assigned yet" before workflow runs)
- GitHub UI may have display delays or caching issues

**Assignment fails for all username variants**
- Check repository permissions for the GitHub token
- Verify `issues: write` permission is granted
- Review error messages in workflow logs (now includes detailed error context for all variants tested)
- Verify the repository allows external user/bot assignments
- Check if Copilot has access to the repository

**Fallback assignment fails**
- Check that fallback user (`rempsyc`) has access to the repository
- Verify user exists and is spelled correctly

### Understanding Copilot Account Types

The workflow assigns to the **GitHub Copilot Bot account** which:
- Has login "Copilot" (capital C) and type "Bot"  
- Is associated with GitHub App "copilot-swe-agent"
- Can be assigned via API using "Copilot", "copilot", or potentially other variants
- May not appear in user search results (it's a bot, not a regular user)

### Debug Information

The workflow logs provide comprehensive information for debugging:
- Issue details (number, title, labels, author, repository)
- Condition evaluation results
- Assignment attempt outcomes
- Detailed error messages with full error context for both primary and fallback assignments
- Clear indicators when both assignment attempts fail

## Investigation Results: Issue #537

**Status**: RESOLVED - The workflow was already working correctly!

### What Actually Happened:

1. **Issue #537 was created** at 2025-09-08T05:18:14Z with title "[Copilot]: Fix auto-assign-copilot workflow (follow-up on #536)"
2. **User wrote "You are not yet assigned"** in the issue description 
3. **Auto-assign workflow triggered** ~3 seconds later at 2025-09-08T05:18:17Z
4. **Assignment succeeded** - logs show "✅ Successfully assigned copilot to the issue!"
5. **GitHub API confirms** Copilot (Bot ID 198982749) is assigned to issue #537

### Key Discovery:

The user reported the workflow "hasn't worked" but **the workflow IS working correctly**. The confusion arose because:
- The issue description was written before the automatic assignment could occur
- Assignment happens within seconds but there may be UI display delays
- GitHub's API accepts "copilot" (lowercase) and assigns the "Copilot" bot successfully

### Technical Details:

- **Assigned Account**: GitHub Copilot Bot (login: "Copilot", type: "Bot")
- **Associated App**: copilot-swe-agent GitHub App  
- **Username Variants**: API accepts both "copilot" and "Copilot"
- **Assignment URL**: https://github.com/apps/copilot-swe-agent

### Solution Implemented:

Enhanced the workflow to test multiple username variants and provide verification feedback for future robustness.

---


To customize the workflow for different repositories:

1. **Change detection criteria**: Modify the `titleMatches` and `labelMatches` conditions
2. **Update fallback assignee**: Change `rempsyc` to your preferred fallback user
3. **Add additional conditions**: Extend the `isCopilotTask` logic as needed

## Security Considerations

- The workflow only has `issues: write` permission (minimal required access)
- Assignment actions are logged for transparency
- Fallback assignment prevents workflow failures from blocking issue creation