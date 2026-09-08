// ABOUTME: Provides the initial Obsidian plugin lifecycle and user entry points.
// ABOUTME: Note selection and opening behaviour will be added in the next paired slice.

const { Notice, Plugin, PluginSettingTab, Setting } = require("obsidian");

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
			callback: () => this.openTodayNote(),
		});

		this.addRibbonIcon("calendar", "Open today note", () => {
			this.openTodayNote();
		});

		this.addSettingTab(new DailyNoteKeySettingTab(this.app, this));
	}

	async loadSettings() {
		this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
	}

	async saveSettings() {
		await this.saveData(this.settings);
	}

	openTodayNote() {
		new Notice("Today note opening will be enabled in the next paired slice.");
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
			.setDesc(
				"The fixed vault note will be selectable here in the next paired slice.",
			)
			.addText((text) => {
				text
					.setPlaceholder("Select one note")
					.setValue(this.plugin.settings.targetPath)
					.onChange(async (value) => {
						this.plugin.settings.targetPath = value;
						await this.plugin.saveSettings();
					});
			});
	}
}

module.exports = DailyNoteKeyPlugin;
