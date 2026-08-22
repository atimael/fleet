---
name: validate-idea
description: "Use when asked to validate an app or product idea, research a market or competitors, or give a build / don't-build call. Digs to the core of the idea (real value, user flow, demand) and returns an honest go/no-go verdict backed by primary sources and hand-checked competitors, not cheerleading."
---

# Validate idea

Get to the core of the idea: the real value, the user flow, the demand, and whether it is worth pursuing at all. Deliver an honest go/no-go verdict. You are not a cheerleader; a well-argued "don't build this" is a success, not a failure.

## Hard verification rules

Conclusions that break these rules don't count.

### 1. Trace every number to its primary source

Market statistics, "professionals lose X hours a week", segment sizes: follow each to the original study and record the year, the methodology, and who paid for the research. If a number only appears in vendor blogs, or is a reprint of someone's column with no underlying data, label it "folklore/marketing, not evidence" and build nothing on it.

### 2. Check every competitor by hand, not by its website

A live landing page is not a live business. For each competitor verify:

- (a) The app listing in the App Store / Google Play for the target region. Open the listing yourself. Record 404s.
- (b) Release date and date of last update.
- (c) Review and rating counts, as a proxy for traction.
- (d) The real published price, not "from $X" copied off an aggregator.

Assign each competitor one status, with evidence: "alive and growing", "alive but zombie (no traction)", or "dead / left the market".

### 3. Don't invent whether the market is taken or free

"The niche is taken" only counts if a competitor actually sells in the target region and has traction. "The niche is free" only counts after you searched for competitors at least three different ways: app stores, the target platform's integration catalogs, and search phrased as the user's pain rather than the category name. One empty search result proves nothing.

### 4. Subagent findings are hypotheses, not facts

If you delegate research to subagents, re-verify their findings yourself against stores and primary sources before they go anywhere near the report.

### 5. End with a "Could not verify" section

List every claim that still rests on secondary sources or assumptions. If a key conclusion depends on an unverified claim, say plainly that the conclusion is shaky and name exactly what needs to be checked by hand.

### 6. Argue both sides, then argue with yourself

Find counterarguments to the idea, and counterarguments to your own counterarguments: trends that are shrinking the market, the risk that the platform ships this natively, and evidence that users are asking for a different solution to the same pain than the one built into this product.

## Report structure

1. **Verdict first.** Go / no-go / conditional go, with the conditions. One paragraph of reasoning.
2. **The idea's core.** The real value, who the user is, the flow they'd actually walk through.
3. **Demand.** Primary-sourced evidence only, per rule 1.
4. **Competitor table.** Name, region, status per rule 2, and the evidence.
5. **Steelman and counter-steelman.** Per rule 6.
6. **Could not verify.** Per rule 5.
