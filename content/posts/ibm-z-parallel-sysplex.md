+++
title = "How IBM Z stays up: Parallel Sysplex, RAS, and the z16"
date = "2026-06-14T12:00:00Z"
draft = false
tags = ["ibm-z", "mainframe", "availability"]
+++

Back in February 2025 I wrote a piece for a course at HdM on how IBM Z mainframes
stay available, more or less forever. It is in German and lives on the HdM Media
Informatics blog, but the engineering in it is interesting enough that I wanted to
write a shorter take here and point people to the original.

The whole thing is built around one number: five nines, 99.999% availability. That
works out to under five minutes of unplanned downtime a year. For a bank or a
payment network that is the difference between a quiet year and a very expensive
one. One study the article cites put the cost of an hour of downtime above $300,000
for most mid-size firms, and past a million for a good share of them.

The way IBM Z gets there is mostly about refusing to have a single point of
failure. Parallel Sysplex ties multiple machines into one logical system, a single
system image, with a Coupling Facility in the middle keeping data in sync and
shifting transactions off any node that falls over. Stretch that across two sites
with GDPS and you get disaster recovery on top of plain availability.

Under that sits the RAS philosophy: reliability, availability, serviceability. In
practice that means ECC catching memory errors, firmware and hardware you can
replace while the system keeps running, predictive failure analysis flagging parts
before they die, and machine learning working through logs to spot trouble early.

The z16 details were the most fun to read about. System Recovery Boost temporarily
throws extra processing power at a machine right after a failure so it catches up
faster. Dynamic Core Sparing swaps in spare CPU cores on its own. And the best one:
before these chips ship, IBM blasts them with a proton beam to simulate cosmic
radiation and shake out the soft errors that stray particles would otherwise cause
in production. I had no idea that was a normal part of building a mainframe.

I wrote this not long before I started a year at IBM, which made going back to it
more fun than I expected. The full article goes into a lot more depth, in German:

[Parallel SysPlex: Wie IBM Z kontinuierliche Verfügbarkeit durch RAS und Innovationen des z16 sicherstellt](https://blog.mi.hdm-stuttgart.de/index.php/2025/02/22/parallel-sysplex-wie-ibm-z-kontinuierliche-verfugbarkeit-durch-ras-und-innovationen-des-z16-sicherstellt/)
