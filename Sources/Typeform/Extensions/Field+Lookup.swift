extension Collection<Field> {
    /// Locate a `Field` in the `Collection` with the specified `Field.ID`.
    ///
    /// This will also examine _sub-groups_ for a matching id.
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: A `Field` anywhere in the hierarchy that matches.
    func field(withId id: Field.ID) -> Field? {
        for field in self {
            if field.id == id {
                return field
            }

            if case .group(let group) = field.properties {
                if let match = group.fields.field(withId: id) {
                    return match
                }
            }
        }

        return nil
    }

    /// Locate a `Field` in the `Collection` with the specified `Reference`.
    ///
    /// This will also examine _sub-groups_ for a matching id.
    ///
    /// - parameters:
    ///   - ref: `Reference` identifier of the `Field` being requested.
    /// - returns: A `Field` anywhere in the hierarchy that matches.
    func field(withRef ref: Reference) -> Field? {
        for field in self {
            if field.ref == ref {
                return field
            }

            if case .group(let group) = field.properties {
                if let subField = group.fields.field(withRef: ref) {
                    return subField
                }
            }
        }

        return nil
    }
}

extension Collection<Field> {
    /// Locate a `Field` which is the immediate parent of the specified `Field.ID`.
    ///
    /// **This always assumes that you are starting at the top of a `Form` hierarchy, and should only be used there.**
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: The direct parent `Field` (or self) anywhere in the hierarchy that matches.
    func parent(forFieldWithId id: Field.ID, in group: Group? = nil) -> Position? {
        for field in self {
            if field.id == id {
                return .field(field, group)
            }

            guard case .group(let group) = field.properties else {
                continue
            }

            if let position = group.fields.parent(forFieldWithId: id, in: group) {
                return position
            }
        }

        return nil
    }

    /// Locate a `Field` which is the immediate parent of the specified `Reference`.
    ///
    /// **This always assumes that you are starting at the top of a `Form` hierarchy, and should only be used there.**
    ///
    /// - parameters:
    ///   - ref: `Reference` identifier of the `Field` being requested.
    /// - returns: The direct parent `Field` (or self) anywhere in the hierarchy that matches.
    func parent(forFieldWithRef ref: Reference, in group: Group? = nil) -> Position? {
        for field in self {
            if field.ref == ref {
                return .field(field, group)
            }

            guard case .group(let group) = field.properties else {
                continue
            }

            if let position = group.fields.parent(forFieldWithRef: ref, in: group) {
                return position
            }
        }

        return nil
    }
}
