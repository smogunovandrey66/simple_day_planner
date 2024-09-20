import 'package:plan_api/plan_api.dart';

extension MapStringDynamic on Map<String, dynamic> {
  ItemSection toItemSection() {
    return ItemSection(this['id'], this['count']);
  }

  Section toSection() {
    return Section(this['id'], this['name']);
  }

  Template toTemplate() {
    return Template(this['id'], this['name']);
  }

  ItemSectionDate toItemSectionDate() {
    return ItemSectionDate(this['id'], this['count'], this['date_execute']);
  }

  SectionDate toSectionDate() {
    return SectionDate(this['id'], this['name']);
  }

  Task toTask() {
    return Task(this['id'], this['name'], this['date_created']);
  }
}

extension ItemSectionExt on ItemSection {
  ItemSection copy([int? id, count]) {
    return ItemSection(id ?? this.id, count ?? this.count);
  }

  ItemSectionDate toItemSectionDate() {
    return ItemSectionDate(0, count);
  }
}

extension SectionExt on Section {
  Section copy([int? id, String? name]) {
    final section = Section(id ?? this.id, name ?? this.name);

    for (final itemSection in items) {
      section.items.add(itemSection.copy());
    }

    return section;
  }

  SectionDate toSectionDate() {
    final sectionDate = SectionDate(0, name);

    for (final itemSection in items) {
      sectionDate.items.add(itemSection.toItemSectionDate());
    }

    return sectionDate;
  }
}

extension TemplateExt on Template {
  Template copy([int? id, String? name]) {
    final template = Template(id ?? this.id, name ?? this.name);

    for (final section in items) {
      template.items.add(section.copy());
    }

    return template;
  }

  Task toTask() {
    final task = Task(0, name);

    for (final section in items) {
      task.items.add(section.toSectionDate());
    }

    return task;
  }
}

extension ItemSectionDateExt on ItemSectionDate {
  ItemSectionDate copy({int? id, count, DateTime? dateime}) {
    return ItemSectionDate(
        id ?? this.id, count ?? this.count, datetime ?? this.datetime);
  }
}

extension SectionDateExt on SectionDate {
  SectionDate copy([int? id, String? name]) {
    final sectionDate = SectionDate(id ?? this.id, name ?? this.name);

    for (final itemSectionDate in items) {
      sectionDate.items.add(itemSectionDate.copy());
    }

    return sectionDate;
  }
}

extension TaskExt on Task {
  Task copy([int? id, String? name, DateTime? dateCreated]) {
    final task =
        Task(id ?? this.id, name ?? this.name, dateCreated ?? this.dateCreated);

    for (final sectionDate in items) {
      task.items.add(sectionDate.copy());
    }

    return task;
  }
}
