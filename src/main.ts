// ABOUTME: Provides the initial Obsidian plugin lifecycle and user entry points.
// ABOUTME: Note selection and opening behaviour will be added in the next paired slice.

import { type App, Notice, Plugin, PluginSettingTab, Setting } from "obsidian";

interface DailyNoteKeySettings {
	targetPath: string;
}

const DEFAULT_SETTINGS: DailyNoteKeySettings = {
	targetPath: "",
};

export default class DailyNoteKeyPlugin extends Plugin {
	settings: DailyNoteKeySettings = DEFAULT_SETTINGS;

	async onload(): Promise<void> {
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

	async loadSettings(): Promise<void> {
		this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
	}

	async saveSettings(): Promise<void> {
		await this.saveData(this.settings);
	}

	private openTodayNote(): void {
		new Notice("Today note opening will be enabled in the next slice.");
	}
}

class DailyNoteKeySettingTab extends PluginSettingTab {
	plugin: DailyNoteKeyPlugin;

	constructor(app: App, plugin: DailyNoteKeyPlugin) {
		super(app, plugin);
		this.plugin = plugin;
	}

	display(): void {
		const { containerEl } = this;
		containerEl.empty();

		new Setting(containerEl)
			.setName("Today note path")
			.setDesc(
				"The fixed vault note will be selectable here in the next slice.",
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
