//
//  CustomAddJarView.swift
//  Savings Jar
//
//  Created by Sean Sullivan on 3/17/25.
//

import SwiftUI

struct CustomAddJarView: View {
    @ObservedObject var viewModel: SavingsViewModel
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var targetAmount: String = ""
    @State private var selectedColor: String = "blue"
    @State private var selectedIcon: String = "banknote.fill"

    let colors = ["blue", "purple", "red", "green", "orange", "yellow"]
    let icons = [
        "banknote.fill", "dollarsign.circle.fill", "house.fill", "car.fill", "airplane",
        "gift.fill", "heart.circle", "star.fill", "briefcase.fill", "graduationcap.fill",
        "cart.fill", "cross.fill", "book.fill", "desktopcomputer", "gamecontroller.fill",
        "tray.fill", "creditcard.fill", "bag.fill", "leaf.fill", "building.fill",
        "globe", "camera.fill", "pawprint.fill", "music.note", "tv.fill",
        "fork.knife", "umbrella.fill", "snowflake", "flag.fill", "bell.fill",
        "bicycle", "bed.double.fill", "tshirt.fill", "tag.fill", "sunglasses",
        "phone.fill", "wrench.fill", "hammer.fill", "paintbrush.fill", "bandage.fill",
        "key.fill", "crown.fill", "theatermasks.fill", "ticket.fill", "film.fill",
        "facemask.fill", "stethoscope", "flashlight.off.fill", "lightbulb.fill", "cloud.fill"
    ]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(height: 50)
                .overlay(
                    Text("Add Savings Jar")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )

            VStack(spacing: 10) {
                VStack(spacing: 2) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("Jar Name", text: $name)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .multilineTextAlignment(.center)
                        .frame(height: 40)
                        .frame(width: 250)
                        .background(Color(.textBackgroundColor))
                        .cornerRadius(8)
                }
                .padding(.top, 10)

                VStack(spacing: 2) {
                    Text("Target Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("Target Amount", text: $targetAmount)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(8)
                        .multilineTextAlignment(.center)
                        .frame(height: 40)
                        .frame(width: 250)
                        .background(Color(.textBackgroundColor))
                        .cornerRadius(8)
                        .onReceive(targetAmount.publisher.collect()) {
                            targetAmount = String($0.prefix(10)).filter { "0123456789.".contains($0) }
                        }
                }

                VStack(spacing: 2) {
                    Text("Color")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        Spacer()
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(getColor(color))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                        .padding(1)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }

                VStack(spacing: 2) {
                    Text("Icon")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
                            ForEach(icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedIcon == icon ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    .frame(height: 220)
                }

                Spacer(minLength: 0)

                HStack(spacing: 10) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.red))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        saveJar()
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.blue))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                    .opacity(name.isEmpty || targetAmount.isEmpty ? 0.7 : 1.0)
                }
                .padding(.bottom, 15)
            }
            .padding(.horizontal)
        }
        .background(Color(.windowBackgroundColor))
        .cornerRadius(12)
        .frame(width: 400, height: 600)
        .clipped()
    }

    private func getColor(_ colorString: String) -> Color {
        switch colorString {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "orange": return .orange
        case "yellow": return .yellow
        default: return .blue
        }
    }

    private func saveJar() {
        guard let target = Double(targetAmount.replacingOccurrences(of: ",", with: ".")), target > 0 else {
            return
        }

        let newJar = SavingsJar(
            name: name,
            currentAmount: 0,
            targetAmount: target,
            color: selectedColor,
            icon: selectedIcon
        )

        viewModel.addSavingsJar(newJar)
        isPresented = false
    }
}
