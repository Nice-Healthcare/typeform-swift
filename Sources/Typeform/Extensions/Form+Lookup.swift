public extension Form {
    /// Locate a `Field` anywhere in the `Form` hierarchy with the specified `Reference`.
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: A `Field` anywhere in the hierarchy that matches.
    func field(withId id: Field.ID) -> Field? {
        for field in fields {
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
    
    /// Locate a `Field` anywhere in the `Form` hierarchy with the specified `Reference`.
    ///
    /// - parameters:
    ///   - ref: `Reference` identifier of the `Field` being requested.
    /// - returns: A `Field` anywhere in the hierarchy that matches.
    func field(withRef ref: Reference) -> Field? {
        for field in fields {
            if field.ref == ref {
                return field
            }
            
            if case .group(let group) = field.properties {
                if let match = group.fields.field(withRef: ref) {
                    return match
                }
            }
        }
        
        return nil
    }
    
    /// Locates the most distant ancestor (i.e. root `Field`) for a specified `Field.ID`.
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: A `Position` indicating the `Field` (& `Group`) of the ancestor if found.
    func ancestor(forFieldWithId id: Field.ID) -> Position? {
        for field in fields {
            if field.id == id {
                return .field(field, nil)
            }
            
            if case .group(let group) = field.properties {
                if group.fields.field(withId: id) != nil {
                    return .field(field, group)
                }
            }
        }
        
        return nil
    }
    
    /// Locates the most distant ancestor (i.e. root `Field`) for a specified `Field.ID`.
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: A `Position` indicating the `Field` (& `Group`) of the ancestor if found.
    func ancestor(forFieldWithRef ref: Reference) -> Position? {
        for field in fields {
            if field.ref == ref {
                return .field(field, nil)
            }
            
            if case .group(let group) = field.properties {
                if group.fields.field(withRef: ref) != nil {
                    return .field(field, group)
                }
            }
        }
        
        return nil
    }
    
    /// Locates the immediate parent for a specified `Field.ID`.
    ///
    /// - parameters:
    ///   - id: Unique identifier of the `Field` being requested.
    /// - returns: A `Position` indicating the `Field` (& `Group`) of the parent if found.
    func parent(forFieldWithId id: Field.ID) -> Position? {
        fields.parent(forFieldWithId: id)
    }
    
    /// Locates the immediate parent for a `Field` specified by a `Reference`.
    ///
    /// - parameters:
    ///   - ref: `Reference` identifier of the `Field` being requested.
    /// - returns: A `Position` indicating the `Field` (& `Group`) of the parent if found.
    func parent(forFieldWithRef ref: Reference) -> Position? {
        fields.parent(forFieldWithRef: ref)
    }
}
