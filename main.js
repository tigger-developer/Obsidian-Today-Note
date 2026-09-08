// ABOUTME: Provides the Obsidian command, ribbon icon, and note configuration.
// ABOUTME: Uses the host file picker and public vault APIs to open one fixed note.

const {
	FuzzySuggestModal,
	Notice,
	Plugin,
	PluginSettingTab,
	Setting,
	TFile,
	setIcon,
} = require("obsidian");

const DEFAULT_SETTINGS = {
	targetPath: "",
};

class DailyNoteKeyPlugin extends Plugin {
	settings = { ...DEFAULT_SETTINGS };

	async onload() {
		await this.loadSettings();

		this.addCommand({
			id: "open-today-note",
			name: "Open today note",
			callback: () => {
				void this.openTodayNote();
			},
		});

		this.ribbonIconEl = this.addRibbonIcon("calendar", "Open today note", () => {
			void this.openTodayNote();
		});
		this.updateRibbonStatus();
		this.registerEvent(this.app.vault.on("create", () => this.updateRibbonStatus()));
		this.registerEvent(this.app.vault.on("delete", () => this.updateRibbonStatus()));
		this.registerEvent(this.app.vault.on("rename", () => this.updateRibbonStatus()));

		this.addSettingTab(new DailyNoteKeySettingTab(this.app, this));
	}

	async loadSettings() {
		this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
	}

	async saveSettings() {
		await this.saveData(this.settings);
	}

	getConfiguredFile() {
		const file = this.app.vault.getAbstractFileByPath(this.settings.targetPath);
		return file instanceof TFile ? file : null;
	}

	updateRibbonStatus() {
		const targetFile = this.getConfiguredFile();
		if (targetFile) {
			setIcon(this.ribbonIconEl, "calendar");
			this.ribbonIconEl.classList.remove("daily-note-key-missing");
			this.ribbonIconEl.setAttribute("aria-label", "Open today note");
			return;
		}

		setIcon(this.ribbonIconEl, "alert-triangle");
		this.ribbonIconEl.classList.add("daily-note-key-missing");
		this.ribbonIconEl.setAttribute(
			"aria-label",
			"Today note is unavailable; configure a note",
		);
	}

	async openTodayNote() {
		const targetFile = this.getConfiguredFile();
		if (!targetFile) {
			this.updateRibbonStatus();
			new Notice("Today note is not configured or is unavailable.");
			return;
		}

		await this.app.workspace.getLeaf(false).openFile(targetFile);
	}

	openFilePicker() {
		new TodayNoteSuggestModal(this.app, async (file) => {
			this.settings.targetPath = file.path;
			await this.saveSettings();
			this.updateRibbonStatus();
		}).open();
	}
}

class TodayNoteSuggestModal extends FuzzySuggestModal {
	constructor(app, onChoose) {
		super(app);
		this.onChoose = onChoose;
	}

	getItems() {
		return this.app.vault
			.getMarkdownFiles()
			.sort((first, second) => first.path.localeCompare(second.path));
	}

	getItemText(file) {
		return file.path;
	}

	onChooseItem(file) {
		void this.onChoose(file);
	}
}

class DailyNoteKeySettingTab extends PluginSettingTab {
	constructor(app, plugin) {
		super(app, plugin);
		this.plugin = plugin;
	}

	display() {
		const { containerEl } = this;
		containerEl.empty();

		new Setting(containerEl)
			.setName("Today note path")
			.setDesc(this.plugin.settings.targetPath || "No note selected")
			.addButton((button) => {
				button.setButtonText("Choose note").onClick(() => {
					this.plugin.openFilePicker();
				});
			})
			.addExtraButton((button) => {
				button
					.setIcon("reset")
					.setTooltip("Clear selected note")
					.onClick(async () => {
						this.plugin.settings.targetPath = "";
						await this.plugin.saveSettings();
						this.plugin.updateRibbonStatus();
						this.display();
					});
			});
	}
}

module.exports = DailyNoteKeyPlugin;
