#!/usr/bin/env python3
"""Professional print-ready diagrams for the Islamian App thesis."""

from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch, Circle, Rectangle, Ellipse, Polygon
from matplotlib.lines import Line2D
import matplotlib.patches as mpatches

OUT = Path(__file__).resolve().parents[1] / "thesis" / "figures" / "diagrams"
OUT.mkdir(parents=True, exist_ok=True)

NAVY = "#1B365D"
MAROON = "#7A1F3D"
GOLD = "#B8956A"
INK = "#1A1A1A"
FILL = "#F7F4EE"
PALE = "#EEF3F8"
GREEN = "#2E5A3C"
WHITE = "#FFFFFF"


def _save(fig, name):
    path = OUT / name
    fig.savefig(path, dpi=220, bbox_inches="tight", facecolor=WHITE, edgecolor="none")
    plt.close(fig)
    print(f"  wrote {path.name}")
    return path


def _box(ax, x, y, w, h, title, lines=None, fc=FILL, ec=NAVY, title_fc=NAVY, title_tc=WHITE):
    ax.add_patch(FancyBboxPatch(
        (x, y), w, h, boxstyle="round,pad=0.015,rounding_size=0.08",
        linewidth=1.4, edgecolor=ec, facecolor=fc, mutation_aspect=0.6,
    ))
    ax.add_patch(FancyBboxPatch(
        (x, y + h - 0.42), w, 0.42, boxstyle="round,pad=0.01,rounding_size=0.06",
        linewidth=0, facecolor=title_fc,
    ))
    ax.text(x + w / 2, y + h - 0.21, title, ha="center", va="center",
            fontsize=9.5, fontweight="bold", color=title_tc, fontname="DejaVu Sans")
    if lines:
        body = "\n".join(lines)
        ax.text(x + 0.12, y + h - 0.58, body, ha="left", va="top",
                fontsize=8, color=INK, fontname="DejaVu Sans", linespacing=1.35)


def _arrow(ax, p1, p2, text=None, color=NAVY, style="-|>", rad=0.0, ls="-"):
    ax.add_patch(FancyArrowPatch(
        p1, p2, arrowstyle=style, mutation_scale=13, linewidth=1.35,
        color=color, connectionstyle=f"arc3,rad={rad}", linestyle=ls,
    ))
    if text:
        mx, my = (p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2
        ax.text(mx, my + 0.12, text, ha="center", va="bottom", fontsize=7.5,
                color=MAROON, fontstyle="italic", fontname="DejaVu Sans",
                bbox=dict(boxstyle="round,pad=0.15", fc=WHITE, ec="none", alpha=0.92))


def draw_architecture():
    fig, ax = plt.subplots(figsize=(11.2, 7.4))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 9.2)
    ax.axis("off")
    ax.set_title("System Architecture of Islamian App", fontsize=14, fontweight="bold",
                 color=NAVY, pad=8, fontname="DejaVu Sans")

    # Presentation
    ax.add_patch(FancyBboxPatch((0.4, 6.4), 13.2, 2.4, boxstyle="round,pad=0.04",
                                fc="#F3EDE4", ec=GOLD, lw=1.3))
    ax.text(7, 8.5, "PRESENTATION LAYER  (Mobile Application)", ha="center",
            fontsize=10, fontweight="bold", color=NAVY)
    _box(ax, 0.8, 6.6, 5.8, 1.7, "Teacher Interface",
         ["Sign in / Sign up", "Create and manage class schedules",
          "Chat with students", "View and edit profile"], title_fc=MAROON)
    _box(ax, 7.4, 6.6, 5.8, 1.7, "Student Interface",
         ["Sign in / Sign up", "View personal class timetable",
          "Chat with teachers", "View and edit profile"], title_fc=NAVY)

    # Application
    ax.add_patch(FancyBboxPatch((0.4, 3.55), 13.2, 2.5, boxstyle="round,pad=0.04",
                                fc=PALE, ec=NAVY, lw=1.3))
    ax.text(7, 5.75, "APPLICATION LAYER", ha="center", fontsize=10, fontweight="bold", color=NAVY)
    items = [
        (0.7, "Authentication\n& Role Check"),
        (3.9, "Schedule\nManagement"),
        (7.1, "Messaging\nService"),
        (10.3, "Profile &\nSession Control"),
    ]
    for x, t in items:
        ax.add_patch(FancyBboxPatch((x, 3.8), 2.9, 1.55, boxstyle="round,pad=0.03",
                                    fc=WHITE, ec=NAVY, lw=1.2))
        ax.text(x + 1.45, 4.55, t, ha="center", va="center", fontsize=8.5, color=INK)

    _arrow(ax, (3.7, 6.6), (3.7, 5.35))
    _arrow(ax, (10.3, 6.6), (10.3, 5.35))

    # Data
    ax.add_patch(FancyBboxPatch((0.4, 0.35), 13.2, 2.85, boxstyle="round,pad=0.04",
                                fc="#EAF2EA", ec=GREEN, lw=1.3))
    ax.text(7, 2.9, "DATA AND CLOUD SERVICES", ha="center", fontsize=10, fontweight="bold", color=GREEN)
    stores = [
        (0.7, "Firebase\nAuthentication\n\nSecure login and\nregistration"),
        (4.0, "Cloud Firestore\n\nTeachers, students,\nschedules, chats"),
        (7.3, "Cloud Storage\n\nProfile pictures"),
        (10.5, "Device Storage\n\nSession and first-\nlaunch preference"),
    ]
    for x, t in stores:
        ax.add_patch(FancyBboxPatch((x, 0.55), 2.95, 2.1, boxstyle="round,pad=0.03",
                                    fc=WHITE, ec=GREEN, lw=1.2))
        ax.text(x + 1.47, 1.55, t, ha="center", va="center", fontsize=8, color=INK)

    _arrow(ax, (7, 3.55), (7, 2.95))
    _save(fig, "fig_4_1_architecture.png")


def draw_usecase():
    fig, ax = plt.subplots(figsize=(11.4, 8.2))
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 11.2)
    ax.axis("off")
    ax.set_title("Use-Case Diagram of Islamian App", fontsize=14, fontweight="bold",
                 color=NAVY, pad=6)

    sys = FancyBboxPatch((3.3, 0.5), 9.4, 10.0, boxstyle="round,pad=0.04",
                         fc="#FAFBFD", ec=NAVY, lw=1.5, linestyle="-")
    ax.add_patch(sys)
    ax.text(8, 10.15, "Islamian App", ha="center", fontsize=11, fontweight="bold", color=NAVY)

    def actor(x, y, label):
        ax.add_patch(Circle((x, y + 1.55), 0.28, fc=WHITE, ec=NAVY, lw=1.5))
        ax.plot([x, x], [y + 1.27, y + 0.55], color=NAVY, lw=1.5)
        ax.plot([x - 0.35, x + 0.35], [y + 1.05, y + 1.05], color=NAVY, lw=1.5)
        ax.plot([x, x - 0.28], [y + 0.55, y], color=NAVY, lw=1.5)
        ax.plot([x, x + 0.28], [y + 0.55, y], color=NAVY, lw=1.5)
        ax.text(x, y - 0.35, label, ha="center", fontsize=10, fontweight="bold", color=NAVY)

    actor(1.35, 5.4, "Teacher")
    actor(14.65, 5.4, "Student")

    def bubble(cx, cy, text, w=3.15, h=0.85):
        e = Ellipse((cx, cy), w, h, fc=WHITE, ec=NAVY, lw=1.25)
        ax.add_patch(e)
        ax.text(cx, cy, text, ha="center", va="center", fontsize=8, color=INK)
        return cx, cy

    shared = [
        (8.0, 9.15, "Register an account"),
        (8.0, 8.15, "Sign in to the system"),
        (8.0, 7.15, "View and edit profile"),
        (8.0, 6.15, "Send and receive messages"),
        (8.0, 5.15, "Log out"),
    ]
    teacher_only = [
        (5.15, 3.85, "Create class schedule"),
        (5.15, 2.75, "Update class schedule"),
        (5.15, 1.65, "Delete class schedule"),
    ]
    student_only = [
        (10.85, 3.30, "View personal timetable"),
        (10.85, 2.10, "Open chat with teacher"),
    ]
    for x, y, t in shared + teacher_only + student_only:
        bubble(x, y, t)

    # Teacher lines
    for y in (9.15, 8.15, 7.15, 6.15, 5.15, 3.85, 2.75, 1.65):
        ax.plot([1.7, 3.55 if y > 4.5 else 3.55], [y if y > 4.5 else 5.9, y], color=NAVY, lw=0.9)
        ax.plot([1.7, 3.55], [6.4 if y < 5 else 6.4, y], color=NAVY, lw=0.0)
        ax.annotate("", xy=(3.55 if y > 4.4 else 3.55, y), xytext=(1.72, 6.55 if y > 4.4 else 6.55),
                    arrowprops=dict(arrowstyle="-", color=NAVY, lw=0.95))

    # cleaner actor-to-use-case lines
    t_targets = [9.15, 8.15, 7.15, 6.15, 5.15, 3.85, 2.75, 1.65]
    for y in t_targets:
        ax.plot([1.72, 6.42 if y > 4.6 else 3.58], [6.55, y], color=NAVY, lw=0.0)
    ax.cla()
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 11.2)
    ax.axis("off")
    ax.set_title("Use-Case Diagram of Islamian App", fontsize=14, fontweight="bold",
                 color=NAVY, pad=6)
    ax.add_patch(FancyBboxPatch((3.3, 0.45), 9.4, 10.05, boxstyle="round,pad=0.04",
                                fc="#FAFBFD", ec=NAVY, lw=1.5))
    ax.text(8, 10.15, "Islamian App", ha="center", fontsize=11, fontweight="bold", color=NAVY)
    actor(1.35, 5.4, "Teacher")
    actor(14.65, 5.4, "Student")
    for x, y, t in shared + teacher_only + student_only:
        bubble(x, y, t)

    def link(x1, y1, x2, y2):
        ax.plot([x1, x2], [y1, y2], color=NAVY, lw=0.95)

    # Teacher to shared + teacher cases
    for y in (9.15, 8.15, 7.15, 6.15, 5.15):
        link(1.72, 6.55, 6.42, y)
    for y in (3.85, 2.75, 1.65):
        link(1.72, 6.55, 3.58, y)
    # Student to shared + student cases
    for y in (9.15, 8.15, 7.15, 6.15, 5.15):
        link(14.28, 6.55, 9.58, y)
    for y in (3.30, 2.10):
        link(14.28, 6.55, 12.42, y)

    ax.text(5.15, 0.75, "Teacher-only functions", ha="center", fontsize=7.5,
            color=MAROON, fontstyle="italic")
    ax.text(10.85, 1.20, "Student-only functions", ha="center", fontsize=7.5,
            color=NAVY, fontstyle="italic")
    _save(fig, "fig_4_2_usecase.png")


def draw_dfd():
    fig, ax = plt.subplots(figsize=(11.2, 7.0))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 8.6)
    ax.axis("off")
    ax.set_title("Context Diagram (Data Flow Diagram — Level 0)", fontsize=13.5,
                 fontweight="bold", color=NAVY, pad=8)

    def entity(x, y, w, h, title):
        ax.add_patch(Rectangle((x, y), w, h, fc=FILL, ec=MAROON, lw=1.5))
        ax.text(x + w / 2, y + h / 2, title, ha="center", va="center",
                fontsize=10, fontweight="bold", color=MAROON)

    def store(x, y, w, h, title):
        ax.plot([x, x], [y, y + h], color=GREEN, lw=2.2)
        ax.plot([x + w, x + w], [y, y + h], color=GREEN, lw=2.2)
        ax.text(x + w / 2, y + h / 2, title, ha="center", va="center", fontsize=8.5, color=GREEN)

    entity(0.35, 3.5, 2.5, 1.5, "Teacher")
    entity(11.15, 3.5, 2.5, 1.5, "Student")

    ax.add_patch(Ellipse((7, 4.25), 4.4, 2.5, fc=PALE, ec=NAVY, lw=1.8))
    ax.text(7, 4.45, "Islamian App\nSystem", ha="center", va="center",
            fontsize=12, fontweight="bold", color=NAVY)

    store(1.6, 0.55, 3.2, 1.15, "D1  User Records")
    store(5.4, 0.55, 3.2, 1.15, "D2  Class Schedules")
    store(9.2, 0.55, 3.2, 1.15, "D3  Conversations")

    def lab_arrow(p1, p2, text, above=True):
        ax.annotate("", xy=p2, xytext=p1,
                    arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=1.15))
        mx, my = (p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2
        ax.text(mx, my + (0.18 if above else -0.28), text, ha="center", fontsize=7,
                color=INK, style="italic")

    lab_arrow((2.85, 4.7), (4.85, 4.7), "schedule details, messages")
    lab_arrow((4.85, 3.85), (2.85, 3.85), "confirmations, student replies", above=False)
    lab_arrow((9.15, 4.7), (11.15, 4.7), "timetable, replies")
    lab_arrow((11.15, 3.85), (9.15, 3.85), "profile, chat messages", above=False)

    lab_arrow((5.4, 3.05), (3.2, 1.70), "store / read users")
    lab_arrow((7.0, 3.00), (7.0, 1.70), "store / read schedules")
    lab_arrow((8.6, 3.05), (10.8, 1.70), "store / read chats")

    ax.text(7, 8.15, "External entities exchange information with the system; data stores hold permanent records.",
            ha="center", fontsize=8.5, color="#444444")
    _save(fig, "fig_4_3_dfd.png")


def draw_erd():
    fig, ax = plt.subplots(figsize=(13.4, 8.6))
    ax.set_xlim(0, 18)
    ax.set_ylim(0, 11.4)
    ax.axis("off")
    ax.set_title("Entity Relationship Diagram of Islamian App", fontsize=14.5,
                 fontweight="bold", color=NAVY, pad=6)

    def entity(x, y, w, h, title, attrs, pk):
        ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="square,pad=0",
                                    fc=WHITE, ec=NAVY, lw=1.6))
        ax.add_patch(Rectangle((x, y + h - 0.48), w, 0.48, fc=NAVY, ec=NAVY, lw=1.6))
        ax.text(x + w / 2, y + h - 0.24, title, ha="center", va="center",
                fontsize=9.5, fontweight="bold", color=WHITE)
        ax.plot([x, x + w], [y + h - 0.48, y + h - 0.48], color=NAVY, lw=1.2)
        yy = y + h - 0.70
        for a in attrs:
            mark = "PK  " if a == pk else ("FK  " if "id" in a.lower() and a != pk and (
                a.endswith("_id") or a in ("sender_id", "receiver_id", "conversation_id", "teacher_id")
            ) else "      ")
            style = "underline" if a == pk else "normal"
            weight = "bold" if a == pk or mark.startswith("FK") else "normal"
            ax.text(x + 0.12, yy, f"{mark}{a}", ha="left", va="center", fontsize=7.6,
                    color=INK, fontfamily="DejaVu Sans", fontweight=weight)
            if a == pk:
                ax.annotate("", xy=(x + 0.12, yy - 0.08), xytext=(x + 1.9, yy - 0.08),
                            arrowprops=dict(arrowstyle="-", color=INK, lw=0.6))
            yy -= 0.30

    entity(0.35, 6.15, 4.05, 4.85, "TEACHER",
           ["teacher_id", "full_name", "email", "phone_no", "department",
            "qualification", "subjects", "gender", "profile_image", "is_online"],
           "teacher_id")
    entity(13.55, 6.15, 4.1, 4.85, "STUDENT",
           ["student_id", "full_name", "email", "department", "field",
            "section", "semester", "profile_image", "is_online"],
           "student_id")
    entity(6.55, 6.55, 4.9, 4.45, "CLASS_SCHEDULE",
           ["schedule_id", "teacher_id", "teacher_name", "department", "field",
            "class_section", "subject", "semester", "day", "class_date", "class_time"],
           "schedule_id")
    entity(4.55, 0.35, 4.7, 3.35, "CONVERSATION",
           ["conversation_id", "participant_ids", "last_message",
            "last_time", "unread_counts", "participant_names"],
           "conversation_id")
    entity(10.55, 0.35, 4.55, 3.05, "MESSAGE",
           ["message_id", "conversation_id", "sender_id",
            "receiver_id", "content", "sent_time"],
           "message_id")

    def rel(p1, p2, label, c1="1", c2="N", dashed=False):
        ax.annotate("", xy=p2, xytext=p1,
                    arrowprops=dict(arrowstyle="-", color=MAROON if dashed else NAVY,
                                    lw=1.25, ls="--" if dashed else "-"))
        mx, my = (p1[0] + p2[0]) / 2, (p1[1] + p2[1]) / 2
        ax.text(mx, my + 0.18, label, ha="center", fontsize=7.4, color=MAROON,
                fontstyle="italic",
                bbox=dict(fc=WHITE, ec="none", pad=0.8, alpha=0.95))
        ax.text(p1[0] + (0.18 if p2[0] > p1[0] else -0.18), p1[1] - 0.18, c1,
                fontsize=8, fontweight="bold", color=NAVY,
                ha="left" if p2[0] > p1[0] else "right")
        ax.text(p2[0] + (-0.18 if p2[0] > p1[0] else 0.18), p2[1] - 0.18, c2,
                fontsize=8, fontweight="bold", color=NAVY,
                ha="right" if p2[0] > p1[0] else "left")

    # Teacher 1 -- N Schedule
    rel((4.40, 8.6), (6.55, 8.6), "creates", "1", "N")
    # Student views schedule (logical match, not stored FK)
    rel((13.55, 8.35), (11.45, 8.35), "views matching timetable", "N", "N", dashed=True)
    # Teacher / Student participate in conversation
    rel((2.35, 6.15), (5.6, 3.70), "takes part in", "1", "N")
    rel((15.55, 6.15), (8.9, 3.70), "takes part in", "1", "N")
    # Conversation 1 -- N Message
    rel((9.25, 1.85), (10.55, 1.85), "contains", "1", "N")

    note = ("Solid lines show stored relationships. The dashed line shows a logical match:\n"
            "a student sees only those schedules whose department, field, section and semester equal the student profile.")
    ax.text(9.0, 10.85, note, ha="center", va="top", fontsize=8, color="#444444")
    _save(fig, "fig_4_4_erd.png")


def draw_activity():
    fig, ax = plt.subplots(figsize=(8.6, 11.0))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 14.2)
    ax.axis("off")
    ax.set_title("Activity Diagram — Teacher Publishes a Class Schedule",
                 fontsize=12.5, fontweight="bold", color=NAVY, pad=8)

    def capsule(y, text, fc=PALE, w=5.6):
        x = 5 - w / 2
        ax.add_patch(FancyBboxPatch((x, y), w, 0.72, boxstyle="round,pad=0.02,rounding_size=0.35",
                                    fc=fc, ec=NAVY, lw=1.2))
        ax.text(5, y + 0.36, text, ha="center", va="center", fontsize=8.4, color=INK)
        return y

    def diamond(cy, text):
        ax.add_patch(Polygon([[5, cy + 0.7], [7.1, cy], [5, cy - 0.7], [2.9, cy]],
                             closed=True, fc="#FFF6E8", ec=MAROON, lw=1.2))
        ax.text(5, cy, text, ha="center", va="center", fontsize=7.8, color=MAROON)

    def vline(y1, y2):
        ax.annotate("", xy=(5, y2), xytext=(5, y1),
                    arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=1.15))

    # start
    ax.add_patch(Circle((5, 13.55), 0.18, fc=NAVY, ec=NAVY))
    ax.text(5.55, 13.55, "Start", fontsize=8, color=NAVY, va="center")
    vline(13.37, 12.85)
    capsule(12.15, "Teacher opens My Class Schedules")
    vline(12.15, 11.55)
    capsule(10.85, "Taps the add (+) button")
    vline(10.85, 10.25)
    capsule(9.55, "Fills department, section, subject, semester, day")
    vline(9.55, 8.95)
    capsule(8.25, "Selects class date and class time")
    vline(8.25, 7.55)
    capsule(6.85, "Taps Submit Schedule")
    vline(6.85, 6.15)
    diamond(5.35, "All required\nfields filled?")
    # yes
    vline(4.65, 4.15)
    ax.text(5.35, 4.55, "Yes", fontsize=7.5, color=GREEN)
    capsule(3.45, "System saves the schedule", fc="#EAF2EA")
    vline(3.45, 2.85)
    capsule(2.15, "New card appears on the home list", fc="#EAF2EA")
    vline(2.15, 1.45)
    ax.add_patch(Circle((5, 1.15), 0.18, fc=WHITE, ec=NAVY, lw=2.2))
    ax.add_patch(Circle((5, 1.15), 0.10, fc=NAVY, ec=NAVY))
    ax.text(5.55, 1.15, "End", fontsize=8, color=NAVY, va="center")
    # no branch
    ax.annotate("", xy=(8.2, 5.35), xytext=(7.1, 5.35),
                arrowprops=dict(arrowstyle="-|>", color=MAROON, lw=1.1))
    ax.text(7.55, 5.55, "No", fontsize=7.5, color=MAROON)
    ax.add_patch(FancyBboxPatch((7.3, 4.55), 2.35, 1.15, boxstyle="round,pad=0.02",
                                fc="#F8E8EC", ec=MAROON, lw=1.1))
    ax.text(8.47, 5.12, "Show error\n(Date / Time required)", ha="center", va="center",
            fontsize=7.5, color=MAROON)
    ax.annotate("", xy=(7.8, 8.61), xytext=(8.47, 5.70),
                arrowprops=dict(arrowstyle="-|>", color=MAROON, lw=1.0,
                                connectionstyle="arc3,rad=-0.25"))
    ax.text(9.35, 7.1, "Return to form", fontsize=7, color=MAROON, rotation=70)
    _save(fig, "fig_4_5_activity.png")


def draw_deployment():
    fig, ax = plt.subplots(figsize=(11.0, 6.6))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 8)
    ax.axis("off")
    ax.set_title("Deployment Diagram of Islamian App", fontsize=14, fontweight="bold",
                 color=NAVY, pad=8)

    ax.add_patch(FancyBboxPatch((0.4, 1.5), 5.3, 5.6, boxstyle="round,pad=0.04",
                                fc=FILL, ec=NAVY, lw=1.4))
    ax.text(3.05, 6.75, "Client Node", ha="center", fontsize=10, fontweight="bold", color=NAVY)
    ax.text(3.05, 6.40, "Android / iOS Smartphone", ha="center", fontsize=8.5, color="#555")
    _box(ax, 0.85, 3.7, 4.4, 2.35, "Islamian App",
         ["Teacher screens", "Student screens", "Local session store"], title_fc=MAROON)

    ax.add_patch(FancyBboxPatch((8.2, 1.5), 5.4, 5.6, boxstyle="round,pad=0.04",
                                fc=PALE, ec=GREEN, lw=1.4))
    ax.text(10.9, 6.75, "Cloud Node", ha="center", fontsize=10, fontweight="bold", color=GREEN)
    ax.text(10.9, 6.40, "Google Firebase (Internet)", ha="center", fontsize=8.5, color="#555")
    _box(ax, 8.6, 4.55, 4.6, 1.5, "Authentication Service", ["Email and password sign-in"], title_fc=GREEN)
    _box(ax, 8.6, 2.7, 4.6, 1.55, "Cloud Database", ["Users, schedules, messages"], title_fc=NAVY)
    _box(ax, 8.6, 1.7, 4.6, 0.85, "File Storage", ["Profile images"], title_fc=GOLD, title_tc=NAVY)

    ax.annotate("", xy=(8.2, 4.4), xytext=(5.7, 4.4),
                arrowprops=dict(arrowstyle="<|-|>", color=MAROON, lw=1.6))
    ax.text(6.95, 4.7, "HTTPS / TLS", ha="center", fontsize=8.5, color=MAROON, fontweight="bold")
    ax.text(6.95, 4.05, "Real-time data sync", ha="center", fontsize=8, color="#444")
    _save(fig, "fig_4_6_deployment.png")


def draw_navigation():
    fig, ax = plt.subplots(figsize=(12.2, 7.6))
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 10)
    ax.axis("off")
    ax.set_title("Screen Navigation Map of Islamian App", fontsize=14, fontweight="bold",
                 color=NAVY, pad=6)

    def node(x, y, w, h, text, fc=PALE, ec=NAVY):
        ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.02,rounding_size=0.12",
                                    fc=fc, ec=ec, lw=1.2))
        ax.text(x + w / 2, y + h / 2, text, ha="center", va="center", fontsize=8, color=INK)

    def arr(a, b):
        ax.annotate("", xy=b, xytext=a, arrowprops=dict(arrowstyle="-|>", color=NAVY, lw=1.05))

    node(6.35, 8.7, 3.3, 0.75, "Splash Screen", fc=FILL, ec=GOLD)
    arr((8.0, 8.7), (8.0, 8.05))
    node(5.7, 7.3, 4.6, 0.75, "Role Selection  (Teacher / Student)", fc=FILL, ec=MAROON)

    # teacher branch
    arr((6.4, 7.3), (3.4, 6.55))
    node(1.3, 5.8, 3.5, 0.75, "Teacher Sign In", fc="#F8E8EC", ec=MAROON)
    arr((3.05, 5.8), (3.05, 5.15))
    node(1.3, 4.4, 3.5, 0.75, "Teacher Sign Up")
    arr((3.05, 4.4), (3.05, 3.75))
    node(1.05, 2.85, 4.0, 0.9, "Teacher Home\nMy Class Schedules", fc="#F8E8EC", ec=MAROON)
    node(0.35, 1.45, 2.5, 0.75, "Add / Edit\nSchedule")
    node(3.05, 1.45, 2.2, 0.75, "Teacher Chat")
    node(5.45, 1.45, 2.2, 0.75, "Teacher Profile")
    arr((2.05, 2.85), (1.55, 2.2))
    arr((3.55, 2.85), (4.15, 2.2))
    arr((4.55, 3.05), (6.55, 2.2))

    # student branch
    arr((9.6, 7.3), (12.6, 6.55))
    node(11.2, 5.8, 3.5, 0.75, "Student Sign In", fc=PALE, ec=NAVY)
    arr((12.95, 5.8), (12.95, 5.15))
    node(11.2, 4.4, 3.5, 0.75, "Student Sign Up")
    arr((12.95, 4.4), (12.95, 3.75))
    node(11.0, 2.85, 3.9, 0.9, "Student Home\nMy Classes", fc=PALE, ec=NAVY)
    node(10.35, 1.45, 2.4, 0.75, "Student Chat")
    node(13.05, 1.45, 2.5, 0.75, "Student Profile")
    arr((12.2, 2.85), (11.55, 2.2))
    arr((13.7, 2.85), (14.3, 2.2))

    ax.text(3.05, 0.55, "Teacher flow", ha="center", fontsize=9, color=MAROON, fontweight="bold")
    ax.text(12.95, 0.55, "Student flow", ha="center", fontsize=9, color=NAVY, fontweight="bold")
    ax.text(8.0, 9.65, "After a successful login the bottom bar switches among Home, Chat and Profile.",
            ha="center", fontsize=8, color="#555")
    _save(fig, "fig_4_7_navigation.png")


def main():
    print("Generating thesis diagrams...")
    draw_architecture()
    draw_usecase()
    draw_dfd()
    draw_erd()
    draw_activity()
    draw_deployment()
    draw_navigation()
    print("Done.")


if __name__ == "__main__":
    main()
