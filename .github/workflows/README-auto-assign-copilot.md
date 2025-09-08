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

The workflow uses a robust assignment approach with verification:

1. **Primary assignment**: Assign to `Copilot` (correct username for Bot ID 198982749)
2. **Wait period**: Brief pause to allow assignment to take effect
3. **Verification**: Check that Copilot is actually assigned via API verification
4. **Fallback assignment**: If Copilot assignment fails, assign to `rempsyc` instead
5. **Error handling**: If both assignments fail, the workflow fails with detailed error messages

**Critical Fix in v3**: The workflow now uses the correct username `Copilot` (capital C) instead of `copilot` (lowercase) and includes mandatory verification to ensure assignments actually take effect. Previous versions reported false success when assignments silently failed.

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

The improved workflow provides detailed logging with verification:

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
🔍 Assigning to: "Copilot" (Bot ID 198982749)
🔍 Verifying assignment took effect...
📋 Current assignees: Copilot (Bot)
✅ SUCCESS: Copilot is actually assigned to the issue!
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

- ✅ Issues matching criteria should be assigned to Copilot (Bot ID 198982749)
- 🔍 Assignment is verified via API to confirm it actually took effect (prevents false positives)
- ⚠️ If verification fails, workflow falls back to assigning `rempsyc` for manual intervention
- ⏭️ Issues not matching criteria should be skipped (no assignment)
- 📝 All actions should be clearly logged with emojis for easy reading
- 🔍 Detailed error information provided when assignments fail
- ⏰ Assignment happens within ~3 seconds of issue creation (verified via API check)

## Troubleshooting

### Common Issues

**Workflow doesn't run**
- Check that the workflow file is in `.github/workflows/`
- Verify the workflow has proper YAML syntax
- Ensure repository has Actions enabled

**Assignment appears to fail but Copilot is actually assigned**
- Check the issue assignees via API or refresh the GitHub web interface  
- Assignment happens ~3 seconds after issue creation
- GitHub UI may have display delays or caching issues

**Assignment reports success but Copilot is NOT actually assigned** 
- **This was a critical bug in previous workflow versions** - fixed in v3
- Previous versions used incorrect username `copilot` (lowercase) instead of `Copilot` (uppercase)
- Previous versions lacked verification, so they reported false success
- Current version uses correct `Copilot` username and verifies assignment actually took effect

**Assignment fails with verification error**
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

**Status**: RESOLVED - The workflow had a critical bug that has been fixed!

### What Actually Happened:

1. **Issue #537 was created** at 2025-09-08T05:18:14Z with title "[Copilot]: Fix auto-assign-copilot workflow (follow-up on #536)"
2. **Auto-assign workflow triggered** ~3 seconds later at 2025-09-08T05:18:17Z
3. **Workflow used wrong username** - tried to assign `copilot` (lowercase) instead of `Copilot` (uppercase)
4. **GitHub API returned success** but assignment did NOT actually take effect
5. **Workflow incorrectly reported success** - logged "✅ Successfully assigned copilot to the issue!"
6. **User manually assigned Copilot** after waiting and seeing the assignment didn't work
7. **Initial investigation was incorrect** - the workflow was reporting false success due to insufficient verification

### Key Discovery:

The workflow had a **critical bug**: 
- Used incorrect username `copilot` (lowercase) instead of `Copilot` (uppercase Bot ID 198982749)
- Lacked proper verification to detect when assignments silently failed
- Reported false success even when assignments didn't take effect

### Technical Details:

- **Correct Account**: GitHub Copilot Bot (login: "Copilot", type: "Bot", ID: 198982749)
- **Associated App**: copilot-swe-agent GitHub App  
- **Previous Issue**: Using `copilot` (lowercase) caused silent assignment failures
- **Assignment URL**: https://github.com/apps/copilot-swe-agent

### Solution Implemented:

1. **Fixed username**: Changed from `copilot` to `Copilot` (correct Bot ID 198982749)
2. **Added mandatory verification**: Always check that assignment actually took effect
3. **Improved error handling**: Detect false positives and provide clear error messages
4. **Enhanced logging**: Show exact Bot ID and verification results

---


To customize the workflow for different repositories:

1. **Change detection criteria**: Modify the `titleMatches` and `labelMatches` conditions
2. **Update fallback assignee**: Change `rempsyc` to your preferred fallback user
3. **Add additional conditions**: Extend the `isCopilotTask` logic as needed

## Security Considerations

- The workflow only has `issues: write` permission (minimal required access)
- Assignment actions are logged for transparency
- Fallback assignment prevents workflow failures from blocking issue creation