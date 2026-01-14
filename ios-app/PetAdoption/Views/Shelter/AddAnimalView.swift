import SwiftUI

struct AddAnimalView: View {
    @Environment(\.dismiss) var dismiss
    let onSuccess: () -> Void
    
    @State private var name = ""
    @State private var species = "dog"
    @State private var breed = ""
    @State private var age = ""
    @State private var size = "medium"
    @State private var description = ""
    @State private var energyLevel = 5
    @State private var goodWithChildren = true
    @State private var goodWithPets = true
    @State private var isSubmitting = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    
                    Picker("Species", selection: $species) {
                        Text("Dog").tag("dog")
                        Text("Cat").tag("cat")
                        Text("Bird").tag("bird")
                        Text("Rabbit").tag("rabbit")
                        Text("Other").tag("other")
                    }
                    
                    TextField("Breed", text: $breed)
                    
                    TextField("Age (years)", text: $age)
                        .keyboardType(.numberPad)
                    
                    Picker("Size", selection: $size) {
                        Text("Small").tag("small")
                        Text("Medium").tag("medium")
                        Text("Large").tag("large")
                    }
                }
                
                Section("Characteristics") {
                    Stepper("Energy Level: \(energyLevel)", value: $energyLevel, in: 0...10)
                    
                    Toggle("Good with Children", isOn: $goodWithChildren)
                    Toggle("Good with Other Pets", isOn: $goodWithPets)
                }
                
                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add Animal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addAnimal()
                    }
                    .disabled(isSubmitting || !isValid)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    var isValid: Bool {
        !name.isEmpty && !breed.isEmpty && !age.isEmpty && !description.isEmpty
    }
    
    func addAnimal() {
        guard let ageInt = Int(age) else {
            errorMessage = "Please enter a valid age"
            showError = true
            return
        }
        
        isSubmitting = true
        
        let animal = CreateAnimalRequest(
            name: name,
            species: species,
            breed: breed,
            age: ageInt,
            gender: gender,
            size: size,
            description: description,
            imageUrl: nil,
            energyLevel: energyLevel,
            goodWithKids: goodWithKids,
            size: size,
            energyLevel: energyLevel,
            goodWithChildren: goodWithChildren,
            goodWithPets: goodWithPets,
            description: description,
            imageUrl = false
                onSuccess()
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isSubmitting = false
            }
        }
    }
}

#Preview {
    AddAnimalView(onSuccess: {})
}
